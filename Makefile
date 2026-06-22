SHELL := /bin/sh

DOCKER_COMPOSE := docker compose
PYTHON := uv run python
POSTGRES_SERVICE := postgres
POSTGRES_DB := backend_devops_interview
POSTGRES_USER := postgres
WAIT_TIMEOUT := 60
FORMAT_EXCLUDES := --exclude "*/migrations/*"

.PHONY: check-deps reset-postgres postgres wait-postgres makemigrations migrate seed runserver init format format-check lint typecheck ci

check-deps:
	@command -v uv >/dev/null 2>&1 || { echo "uv is required: https://docs.astral.sh/uv/getting-started/installation/"; exit 1; }
	@command -v docker >/dev/null 2>&1 || { echo "Docker is required: https://docs.docker.com/get-docker/"; exit 1; }
	@docker compose version >/dev/null 2>&1 || { echo "Docker Compose plugin is required."; exit 1; }
	@docker info >/dev/null 2>&1 || { echo "Docker daemon is not running or is not accessible."; exit 1; }
	@$(DOCKER_COMPOSE) config >/dev/null
	@echo "Developer dependencies are available."

postgres: check-deps
	$(DOCKER_COMPOSE) up -d $(POSTGRES_SERVICE)

reset-postgres: check-deps
	$(DOCKER_COMPOSE) down -v

wait-postgres:
	@echo "Waiting for PostgreSQL..."
	@elapsed=0; \
	until $(DOCKER_COMPOSE) exec -T $(POSTGRES_SERVICE) pg_isready -U $(POSTGRES_USER) -d $(POSTGRES_DB) >/dev/null 2>&1; do \
		elapsed=$$((elapsed + 1)); \
		if [ $$elapsed -ge $(WAIT_TIMEOUT) ]; then \
			echo "PostgreSQL did not become ready within $(WAIT_TIMEOUT) seconds."; \
			exit 1; \
		fi; \
		sleep 1; \
	done
	@echo "PostgreSQL is ready."

migrate:
	$(PYTHON) manage.py migrate

makemigrations:
	$(PYTHON) manage.py makemigrations blog $(if $(NAME),--name $(NAME))

seed:
	$(PYTHON) manage.py seed

runserver:
	$(PYTHON) manage.py runserver

init: reset-postgres postgres wait-postgres migrate seed runserver

format:
	uv run ruff format $(FORMAT_EXCLUDES) .

format-check:
	uv run ruff format --check $(FORMAT_EXCLUDES) .

lint:
	uv run ruff check .

typecheck:
	uv run mypy blog core manage.py conftest.py

ci: format-check lint typecheck
