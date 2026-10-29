# DormSupport

## О репозитории

Инфраструктурный репозиторий для простого запуска всего проекта: объединяет пользовательский интерфейс, сервисы, базы данных и Kafka с помощью Docker Compose.

**Технологии:** Docker, Docker Compose, Make, PostgreSQL, Kafka.

**Ручки:** собственных API-ручек нет.

## Запуск всего проекта

Потребуются Git, Make и Docker Desktop с Docker Compose. При первом запуске:

```bash
git clone --recurse-submodules -b dev https://github.com/GKDI-Team/dorm-support-infrastructure.git
cd dorm-support-infrastructure
make up
```

После клонирования для запуска всего проекта достаточно `make up` из этой папки. Команда обновляет репозиторий и подмодули, затем собирает и запускает контейнеры; для обновления нужен доступ к GitHub.

Приложение: http://localhost:8080. Для Telegram задайте `TELEGRAM_BOT_TOKEN` и `TELEGRAM_CHAT_ID`; если он не нужен — `TELEGRAM_ENABLED=false`.

## Сервисы

- `gateway-service` — внешний вход приложения, порт `8080`.
- `frontend` — веб-интерфейс, доступный через Gateway на порту `8080`.
- `auth-service` — авторизация и пользователи.
- `issues-service` — заявки и категории.
- `notifications-service` — уведомления о заявках в Telegram.
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

Интерфейс и API используют общий адрес `http://localhost:8080`. Интерфейс не публикует отдельный внешний порт.

Внутри Docker каждый Spring Boot-сервис слушает стандартный порт `8080`. Из приложений наружу опубликован только Gateway. PostgreSQL разделён на три контейнера: `identity_db`, `issues_db` и `notifications_db`; внутри Docker каждый использует стандартный порт `5432`. Kafka использует внутренний порт `9092` и внешний порт `29092`.

SQL-файлы сервисов подключены к соответствующим PostgreSQL-контейнерам через
`/docker-entrypoint-initdb.d/`. Они выполняются автоматически только при создании
нового тома Docker. При уже существующем томе `git pull` или `make up` не
перезапускают начальную инициализацию базы.

`notifications-service` читает события заявок из Kafka и отправляет уведомления в Telegram при соответствующей настройке.

Полезные команды:

```bash
make status  # состояние контейнеров и подмодулей
make logs    # логи всех контейнеров
make down    # остановить окружение
```
