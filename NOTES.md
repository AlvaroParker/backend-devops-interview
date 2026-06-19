## Developer experience improvements:

- Setup `Makefile` with common commands:
  - `make init`: Initializes the postgres docker services, runs migrations, seed and starts the application.
  - `make migrate`: Runs migrations.
  - `make seed`: Seeds the database with initial data.
  - `make ci`: Runs all checks (lint, test, etc.) that ensure code quality and correctness.
  - `make lint`: Runs linting to check code style.
  - `make format`: Runs formatting to ensure code is properly indented and styled.
  - `make typecheck`: Runs type checking to ensure type safety.

- Setup `docker-compose.yml` with a Postgres database service.

## CI:

- Setup CI pipeline with GitHub Actions.

## Seed improvements:

- Improved seed data generation speed. Specifically the comments, now weights are precomputed.
