.PHONY: up pull build down logs status config

pull:
	git pull --ff-only origin dev
	git submodule sync --recursive
	git submodule update --init --recursive

up: pull
	docker compose up --build

build: pull
	docker compose build

down:
	docker compose down

logs:
	docker compose logs -f

status:
	docker compose ps
	git submodule status

config:
	docker compose config
