# FreshPrice Bugs And Risks

## Known Risks

- The root workspace is not a git repository. Worktree checks must be run inside the relevant subproject repository when needed.
- `/api/vegetables` is removed and returns 410. New callers should use `/api/freshprice/products`.

## Open Bugs

- No reproducible FreshPrice runtime bugs were confirmed during the 2026-07-01 documentation pass.
