# Stage 1: Scraper
FROM node:18-slim AS scraper
WORKDIR /app
COPY scraper/package.json scraper/package-lock.json ./
RUN npm install
COPY scraper/ .
RUN apt-get update && apt-get install -y chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN node scrape.js

# Stage 2: Web Server
FROM python:3.9-slim
WORKDIR /app
COPY --from=scraper /app/scraped_data.json /app/scraped_data.json
COPY server/ /app/
RUN pip install flask
CMD ["python", "app.py"]

