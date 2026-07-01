# Portfolio Project Spec

Last investigated: 2026-07-01

## Summary

The portfolio app in `jamesabilong` is a personal React/Vite site for James Abilong.

## Code Areas

| Path | Purpose | Stack |
| --- | --- | --- |
| `jamesabilong` | Personal portfolio frontend | React 19, TypeScript, Vite, React Router, lucide-react |
| `jamesabilong/public` | Static assets, favicon, resume files | Static files |
| `jamesabilong/deploy` | nginx and VPS deployment scripts/config | nginx, shell |

## Frontend Structure

- Entry point: `jamesabilong/src/main.tsx`.
- App shell/routes: `jamesabilong/src/App.tsx`.
- Pages: `jamesabilong/src/pages`.
- Reusable components: `jamesabilong/src/components`.
- Shared data: `jamesabilong/src/data.ts`.
- Styling: `jamesabilong/src/styles.css`.

## Scripts

- `npm run dev`
- `npm run build`
- `npm run preview`

## Important Conventions

- Node engine requires `>=20.19.0`.
- Keep portfolio changes isolated from FreshPrice and Sugilanon unless explicitly requested.
- Use existing React/Vite patterns in the app before introducing new tooling.
