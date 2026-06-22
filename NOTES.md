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

## Changes made on github:

- Enforce squash-rebase when merging PRs to ensure a clean commit history.
- Enforce CI jobs pass before merging PRs.
- Disable force commits to main
- Enforce branch protection rules to prevent direct pushes to main.
- Enable auto merging
- Require PR to commit to main
- Require linear history

## Seed improvements:

- Improved seed data generation speed. Specifically the comments, now weights are precomputed.

## Speed up queries:

- Added new indexes on models:
  - `User.email` to speed up api endpoint `/api/users/find?email=foo-bar`
  - partial `Post.created_at` index for published post endpoints: `GET /api/posts`, `/api/posts/search`, and `/api/posts/by-tag/{slug}`
  - `Comment(post, created_at)` to speed up chronological comment loading for `GET /api/posts/{id}`

- Enabled [`pg_trgm`](https://www.postgresql.org/docs/current/pgtrgm.html) and added trigram indexes on `Post.title` and `Post.body` to speed up `icontains` search.

AI transcript for this is available under `ai/transcript.md`

## TODOS if more time:

- Add actual performance monitoring and optimization to be able to compare the improvements before and after the changes.
- Setup a `Dockerfile` image for the application to be able to easily deploy in prod via docker image registry.
- Enforce docs generation and code quality checks via CI.
- Migrate to a `justfile` for task management just because :)
- Enforce LSP config for common code editors.

Main reasons to delay this is because is not a priority and does not improve the developer experience much which was my main focus for this test :)

ps: I have the habit to write in english. Specially for writing up notes, documentation and programming :)
