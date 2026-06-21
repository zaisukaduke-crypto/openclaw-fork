FROM node:24-slim

ENV NODE_ENV=production
ENV PORT=8080

RUN npm install -g openclaw@2026.6.8

COPY dist/control-ui /usr/local/lib/node_modules/openclaw/dist/control-ui

RUN mkdir -p /root/.openclaw && echo '{\
  "gateway": {\
    "mode": "local",\
    "auth": {\
      "mode": "token",\
      "token": "openclaw764484"\
    },\
    "http": {\
      "endpoints": {\
        "chatCompletions": {"enabled": true}\
      }\
    },\
    "controlUi": {\
      "allowedOrigins": ["https://openclaw-fork-production-1760.up.railway.app"],\
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
          {"id": "deepseek-v4-flash-free", "name": "DeepSeek V4 Flash Free", "contextWindow": 128000, "maxTokens": 65536},\
          {"id": "mimo-v2.5-free", "name": "MiMo V2.5 Free", "contextWindow": 128000, "maxTokens": 65536},\
          {"id": "nemotron-3-ultra-free", "name": "Nemotron 3 Ultra Free", "contextWindow": 128000, "maxTokens": 65536},\
          {"id": "north-mini-code-free", "name": "North Mini Code Free", "contextWindow": 128000, "maxTokens": 65536},\
          {"id": "big-pickle", "name": "Big Pickle", "contextWindow": 128000, "maxTokens": 65536}\
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
