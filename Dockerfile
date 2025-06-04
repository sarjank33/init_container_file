# Stage 1: Builder
FROM node:20-bullseye AS builder

ENV PUPPETEER_DOWNLOAD_BASE_URL=https://storage.googleapis.com/chrome-for-testing-public

RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libgbm1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libpangocairo-1.0-0 \
    libcairo2 \
    libpango1.0-0 \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    librsvg2-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

COPY package.json /src/package.json
RUN yarn install --frozen-lockfile

COPY . /src

# Stage 2: Runtime
FROM node:20-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libgbm1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libpangocairo-1.0-0 \
    libcairo2 \
    libpango1.0-0 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Only copy the necessary files from builder
COPY --from=builder /src /src
COPY --from=builder /src/dist/apps/subscriptions-ms /src

CMD ["node", "main.js"]
