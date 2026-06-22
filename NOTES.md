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

## Speed up queries:

- Added new indexes on models:
  - `User.email` to speed up api endpoint `/api/users/find?email=foo-bar`
  - partial `Post.created_at` index for published post endpoints: `GET /api/posts`, `/api/posts/search`, and `/api/posts/by-tag/{slug}`
  - `Comment(post, created_at)` to speed up chronological comment loading for `GET /api/posts/{id}`

- Enabled [`pg_trgm`](https://www.postgresql.org/docs/current/pgtrgm.html) and added trigram indexes on `Post.title` and `Post.body` to speed up `icontains` search.
