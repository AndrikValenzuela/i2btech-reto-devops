FROM node:22-alpine

WORKDIR /app

COPY src/package*.json ./
RUN npm ci --omit=dev

COPY src/ ./

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "index.js"]
