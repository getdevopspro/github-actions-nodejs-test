# github-actions-nodejs-test

## Instruction index

Read applicable entries in order before the repository guidance below.
Resolve local paths from this repository's root. Read each resolved file once
to avoid duplicate loading and cycles. Resolve references inside imported files
from their real target directories after following symlinks.

### Shared context

These files are optional. Read available files in this order, skipping absent
files and reporting broken or unreadable links:

1. `.agents/organization/AGENTS.md` — organization-wide policy and shared context.
2. `.agents/workspace/AGENTS.md` — workspace scope, coordination, and decisions.

Apply organization guidance, then workspace guidance, then the repository
instructions below. More specific applicable instructions take precedence.

## Repository guidance

- This is a TypeScript/Express fixture for shared GitHub Actions and Docker builds.
  `src/index.ts` starts the server, serves `GET /` and `GET /health`, and
  uses `PORT` with a default of 3000.
- `tsconfig.json` compiles `src/` into `build/`. Keep `package.json` and
  `package-lock.json` aligned; treat `build/`, `node_modules/`, `.npm/`,
  and `coverage/` as generated or local content.
- Keep application behavior, `Dockerfile`, `docker-bake.hcl`, Compose files,
  and `.github/workflows/` consistent when changing the fixture.
- Shared workflows are consumed through pinned version references. Editing the
  sibling `github-actions` checkout does not change those referenced versions.

## Development and validation

- Use `npm run lint`, `npm test`, and `npm run build` for local checks.
  CI installs with `npm ci --ignore-scripts` before linting and testing.
- `npm run dev` watches the TypeScript source; `npm start` runs the compiled
  `build/index.js`. `npm run lint:fix` rewrites source.
- `src/index.test.ts` currently checks basic assertions, not the Express
  endpoints. Add behavior-focused tests when changing HTTP behavior.
- `docker-bake.hcl` defines a `build` target for amd64 and arm64.
  The workflows can publish images, update versions, and manage
  PR labels/checks; do not trigger them merely to validate documentation.
