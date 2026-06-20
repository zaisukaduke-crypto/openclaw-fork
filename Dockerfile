FROM node:24-slim

ENV NODE_ENV=production
ENV PORT=8080

RUN npm install -g openclaw@2026.6.8

RUN mkdir -p /root/.openclaw && echo '{\
  "gateway": {\
    "mode": "local",\
    "auth": {\
      "mode": "token",\
      "token": "openclaw"\
    },\
    "http": {\
      "endpoints": {\
        "chatCompletions": {"enabled": true}\
      }\
    },\
    "controlUi": {\
      "allowedOrigins": ["https://openclaw-production-b70b.up.railway.app"],\
      "dangerouslyDisableDeviceAuth": true\
    }\
  },\
  "models": {\
    "providers": {\
      "zen": {\
        "baseUrl": "https://opencode.ai/zen/v1",\
        "apiKey": "${OPENCODE_API_KEY}",\
        "api": "openai-completions",\
        "models": [\
          {"id": "deepseek-v4-flash-free", "name": "DeepSeek V4 Flash Free", "contextWindow": 128000, "maxTokens": 32768}\
        ]\
      }\
    }\
  },\
  "agents": {\
    "defaults": {\
      "model": {\
        "primary": "zen/deepseek-v4-flash-free"\
      }\
    }\
  }\
}' > /root/.openclaw/openclaw.json

EXPOSE 8080

CMD openclaw gateway --port 8080 --bind auto --token openclaw
