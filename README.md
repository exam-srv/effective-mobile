# Веб приложение:
Веб-приложение, развёрнутое в Docker-контейнерах с Nginx в качестве reverse proxy, оба сервиса находятся в изолированной Docker-сети `app-network`.

# Стек использованных технологий:
Backend: Node.js 20 (node:20-slim)
Reverse Proxy: Nginx (nginx:alpine)
Docker Compose
CI/CD: GitHub Actions + SSH-деплой
Хост: Debian 13 (Proxmox VM)


├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── nginx/
│   └── nginx.conf
├── .github/
│   └── workflows/
│       └── deploy.yml
├── deploy.sh
├── docker-compose.yml
├── .gitignore
└── README.md

# Как это работает:
1. Клиент отправляет запрос на `http://localhost` или `http://exam-srv.ru` (порт 80 хоста) 
2. Docker пробрасывает его в контейнер `nginx`
3. Nginx читает кастомный `nginx.conf` и проксирует запрос по имени сервиса: `proxy_pass http://backend:8080`
4. Docker DNS разрешает `backend` во внутренний IP-адрес контейнера
5. Node.js-приложение отвечает `"Hello from Effective Mobile!"`
6. Ответ возвращается клиенту через Nginx

# GitHub Actions + SSH-деплой
При изменения кода в приложении

# Запуск веб приложения:
Клонируйте репозиторий:
   bash
   ```
   git clone https://github.com/exam-srv/effective-mobile
   cd effective-mobile
   docker compose up -d --build
   ```
Проверка работоспособности:
 bash
   ```
   curl http://localhost
   docker exec webapp_frontend curl -s http://backend:8080
   ```
Вывод команд: Hello from Effective Mobile!
