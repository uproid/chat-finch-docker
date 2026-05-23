# Chat App — Finch Framework (Dart)

A real-time chat example application built with the [Finch](https://pub.dev/packages/finch) web framework for Dart. It demonstrates WebSocket-based messaging, channel management, user authentication, MySQL persistence, and Jinja2 (`.j2.html`) templating — all running inside Docker.

**GitHub:** [https://github.com/uproid/chat-finch-docker](https://github.com/uproid/chat-finch-docker)

---

## Features

- User registration and login with session-based authentication
- Real-time messaging via WebSockets (channels + direct messages)
- Channel creation and management
- MySQL database with automatic migrations
- Jinja2 HTML templating with TailwindCSS
- Static assets served via Nginx
- Hot-reload during development via `finch serve`

## Project Structure

```
lib/
  app.dart                  # App entry point
  configs/setting.dart      # FinchConfigs (MySQL, ports, paths)
  controllers/              # Auth, home, workspace controllers
  db/                       # MySQL table helpers (users, channels, chats)
  models/                   # Dart models (User, Channel, Chat)
  route/
    web_route.dart          # HTTP routes
    socket_route.dart       # WebSocket event handlers
  widgets/                  # Jinja2 HTML templates
  languages/                # i18n (English)
migrations/                 # MySQL migration SQL files
public/                     # Static assets (JS, CSS)
docker/nginx.conf           # Nginx reverse proxy config
```

## Services (Docker Compose)

| Service       | Description                              | Port        |
|---------------|------------------------------------------|-------------|
| `finch-chat`  | Dart/Finch app server                    | 2020, 2121  |
| `mysql`       | MySQL 8 database                         | 3306        |
| `nginx`       | Reverse proxy / static file serving      | 2222        |
| `nodejs`      | TailwindCSS watcher (dev)                | —           |

## Requirements

- [Docker](https://www.docker.com/) & Docker Compose

## Run

```shell
docker compose up --build
```

The app will be available at [http://localhost:2020](http://localhost:2020).

## Environment Variables

The following variables can be configured (defaults shown):

| Variable          | Default           | Description                  |
|-------------------|-------------------|------------------------------|
| `DOMAIN_PORT`     | `2020`            | HTTP port for the app        |
| `MYSQL_HOST`      | `localhost`       | MySQL host                   |
| `MYSQL_PORT`      | `3306`            | MySQL port                   |
| `MYSQL_USER`      | `example_user`    | MySQL username               |
| `MYSQL_PASSWORD`  | `example_password`| MySQL password               |
| `MYSQL_DATABASE`  | `example_db`      | MySQL database name          |
| `WIDGETS_PATH`    | `./lib/widgets`   | Path to Jinja2 templates     |
| `PUBLIC_DIR`      | `./public`        | Path to static assets        |

## WebSocket Events

| Event                  | Direction      | Description                          |
|------------------------|----------------|--------------------------------------|
| `channels`             | client → server| Fetch all channels                   |
| `new_channel`          | client → server| Create a new channel                 |
| `users`                | client → server| Fetch all users                      |
| `channel_chats`        | client → server| Fetch messages for a channel         |
| `send_chat`            | client → server| Send a message to a channel          |
| `send_message_to_user` | client → server| Send a direct message to a user      |
| `users_messages`       | client → server| Fetch direct messages between users  |

## Links

- [Finch Framework](https://pub.dev/packages/finch)
- [Finch on GitHub](https://github.com/uproid/finch)
- [Finch Documentation](https://github.com/uproid/finch/tree/master/doc)