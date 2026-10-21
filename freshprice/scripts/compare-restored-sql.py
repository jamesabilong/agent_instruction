"""Compare pg_restore SQL without exposing data; allow only known deparser changes.

Input must already exclude owners/ACLs and normalize dump comments/restrict tokens.
COPY row order is irrelevant; duplicate rows remain significant.
"""
import collections
import json
import pathlib
import re
import sys

literal = r"'(?:[^']|'')*'::character varying"
array_cast = re.compile(r"\(\(ARRAY\[(" + literal + r"(?:, " + literal + r")*)\]\)::text\[\]\)")
literal_pattern = re.compile(literal)


def canonicalize(text):
    rewrites = 0
    output = []
    row_counts = []
    lines = text.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith('COPY ') and line.endswith(' FROM stdin;'):
            output.append(line)
            rows = []
            i += 1
            while i < len(lines) and lines[i] != '\\.':
                rows.append(lines[i])
                i += 1
            if i == len(lines):
                raise ValueError('Unterminated COPY block')
            output.extend(sorted(rows))
            output.append('\\.')
            row_counts.append(len(rows))
        else:
            # Restrict equivalence to CHECKs and partial-index schema predicates.
            if (line.lstrip().startswith('CONSTRAINT ') and ' CHECK ' in line) or (
                line.startswith(('CREATE INDEX ', 'CREATE UNIQUE INDEX ')) and ' WHERE ' in line
            ):
                line, n = array_cast.subn(
                    lambda m: '(ARRAY[' + ', '.join('(' + x + ')::text' for x in literal_pattern.findall(m[1])) + '])',
                    line,
                )
                rewrites += n
            output.append(line)
        i += 1
    return output, {'copyBlocks': len(row_counts), 'rows': sum(row_counts), 'castRewrites': rewrites}


if __name__ == '__main__':
    left, left_stats = canonicalize(pathlib.Path(sys.argv[1]).read_text())
    right, right_stats = canonicalize(pathlib.Path(sys.argv[2]).read_text())
    equal = left == right
    report = {'equal': equal, 'original': left_stats, 'restored': right_stats,
              'scope': 'schema excluding owners/ACLs, complete COPY row multisets and sequence values'}
    if len(sys.argv) > 3:
        pathlib.Path(sys.argv[3]).write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report))
    sys.exit(0 if equal else 1)
