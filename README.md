# DormSupport

## Сервисы

- `gateway-service` — внешний вход приложения, порт `8080`.
- `frontend` — минимальная страница проверки сервисов, порт `3000`.
- `auth-service` — заготовка сервиса авторизации.
- `issues-service` — заготовка сервиса заявок и `GET /api/v1/issues`.
- `notifications-service` — заготовка сервиса уведомлений.
- `documents` — проектная документация.

## Запуск

Требуется Docker Desktop с Docker Compose.

```bash
docker compose up --build
```

Проверки:

```bash
curl http://localhost:8080/health
curl http://localhost:8080/api/v1/issues
```

Открыть страницу проверки сервисов: http://localhost:3000

Внутри Docker каждый Spring Boot-сервис слушает стандартный порт `8080`. Наружу опубликован только Gateway. PostgreSQL разделён на три контейнера: `identity_db`, `issues_db` и `notifications_db`; внутри Docker каждый использует стандартный порт `5432`. Kafka использует внутренний `9092` и внешний listener `29092`.

## Быстрый запуск

Первое клонирование проекта вместе со всеми сервисами:

```bash
git clone --recurse-submodules -b dev https://github.com/GKDI-Team/dorm-support-infrastructure.git
cd dorm-support-infrastructure
make up
```

Для уже склонированного проекта:

```bash
make up
```

Команда подтягивает изменения infrastructure-репозитория, обновляет submodules и запускает Docker Compose.

Полезные команды:

```bash
make status  # состояние контейнеров и submodules
make logs    # логи всех контейнеров
make down    # остановить окружение
```
