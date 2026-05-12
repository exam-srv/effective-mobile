# Веб приложение:
Веб-приложение, развёрнутое в Docker-контейнерах с Nginx в качестве reverse proxy, оба сервиса находятся в изолированной Docker-сети `app-network`.
адрес dns имени сервера где развёрнуто приложение: http://exam-srv.ru/

# Стек использованных технологий:
Хост: Debian 13 (Proxmox VM)

   Docker Compose

      Backend: Node.js 20 (node:20-slim)

      Reverse Proxy: Nginx (nginx:1.25-alpine)

CI/CD: GitHub Actions + SSH-деплой

# Структура проекта

├── backend/

│   ├── Dockerfile

│   ├── package.json

│   ├── .dockerignore

│   └── server.js

├── nginx/

│   ├── .dockerfile

│   └── nginx.conf

├── .github/

│   └── workflows/

│       └── deploy.yml

├── deploy.sh

├── docker-compose.yml

├── .gitignore

├── .env.example

└── README.md

# Как это работает:
1. Клиент отправляет запрос на `http://localhost` или `http://exam-srv.ru` (порт 80 хоста) 
2. Docker пробрасывает его в контейнер `nginx`
3. Nginx читает файл конфиугации `nginx.conf` и проксирует запрос по имени сервиса: `proxy_pass http://backend:8080`
4. Docker DNS разрешает `backend` во внутренний IP-адрес контейнера
5. Node.js-приложение отвечает `"Hello from Effective Mobile!"`
6. Ответ возвращается клиенту через Nginx

# GitHub Actions + SSH-деплой (VisualCode studio + Git)
При изменения кода в приложении - обновление происходит автоматически по следующему сценарию:
## Триггер
Вы выполняете `git add ., git commit и git push origin main`. GitHub фиксирует изменение в ветке main и запускает пайплайн Deploy.
## GitHub Runner
GitHub Actions выделяет чистую виртуальную машину (ubuntu-latest), клонирует вашу последнюю версию репозитория и безопасно настраивает SSH-агент. Приватный ключ подтягивается из GitHub Secrets, нигде не логируется и не сохраняется в образе раннера.
## Подключение к серверу
Раннер устанавливает SSH-соединение с Proxmox VM (Debian 13), используя IP-адрес, нестандартный порт (221) и логин из секретов. Соединение работает без ручного ввода паролей благодаря аутентификации по ключу.
## Выполнение деплоя на сервере
Через SSH запускается локальный скрипт deploy.sh
## Завершение пайплайна
GitHub Actions получает статус "успешно", помечает запуск зелёной галочкой. Приложение уже работает с новой версией кода. В

# Запуск веб приложения:
Клонируйте репозиторий:
   bash
   ```
   git clone https://github.com/exam-srv/effective-mobile
   cd effective-mobile
   docker compose up -d --build
   ```

Проект поддерживает настройку без правки `docker-compose.yml`. Создайте файл `.env` на основе шаблона:
bash
```
cp .env.example .env
```

Проверка работоспособности:
 bash
   ```
   curl http://localhost
   docker exec webapp_frontend curl -s http://backend:8080
   ```
Вывод команд:  Hello from Effective Mobile!
