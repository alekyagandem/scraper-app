# Stage 1: Scraper
FROM node:18-slim AS scraper
WORKDIR /app
COPY scraper/package.json scraper/package-lock.json ./
RUN npm install
COPY scraper/ .
RUN apt-get update && apt-get install -y chromium \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
RUN node scrape.js

# Stage 2: Web Server
FROM python:3.9-slim
WORKDIR /app
COPY --from=scraper /app/scraped_data.json /app/scraped_data.json
COPY server/ /app/
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]


