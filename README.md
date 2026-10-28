# DormSupport

## Сервисы

- `gateway-service` — внешний вход приложения, порт `8080`.
- `frontend` — web-интерфейс, доступный через Gateway на порту `8080`.
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

Открыть приложение: http://localhost:8080

Открыть Swagger Gateway: http://localhost:8080/swagger-ui.html

Frontend и API используют один origin `http://localhost:8080`. Frontend не публикует отдельный внешний порт.

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

SQL-файлы сервисов подключены к соответствующим PostgreSQL-контейнерам через
`/docker-entrypoint-initdb.d/`. Они выполняются автоматически только при создании
нового Docker volume. При уже существующем volume `git pull` или `make up` не
перезапускают начальную инициализацию базы.

`notifications-service` читает события заявок из Kafka и пока сохраняет их в
`notifications_db`, выводя результат обработки в логи. Telegram-доставка отключена
до отдельного этапа настройки бота.

Полезные команды:

```bash
make status  # состояние контейнеров и submodules
make logs    # логи всех контейнеров
make down    # остановить окружение
```
