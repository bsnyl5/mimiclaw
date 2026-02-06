# MimiClaw: Pocket AI Assistant on a $5 Chip

<p align="center">
  <img src="assets/banner.png" alt="MimiClaw" width="480" />
</p>

**The world's first AI assistant on a $5 chip. No Linux. No Node.js. Just pure C**

MimiClaw turns a tiny ESP32-S3 board into a personal AI assistant. Plug it into USB power, connect to WiFi, and talk to it through Telegram — it handles any task you throw at it and evolves over time with local memory — all on a chip the size of a thumb.

## Meet MimiClaw

- **Tiny** — No Linux, no Node.js, no bloat — just pure C
- **Handy** — Message it from Telegram, it handles the rest
- **Loyal** — Learns from memory, remembers across reboots
- **Energetic** — USB power, 0.5 W, runs 24/7
- **Lovable** — One ESP32-S3 board, $5, nothing else

## How It Works

```
                         ┌─────────────── Agent Loop ───────────────┐
                         │                                          │
 ┌───────────┐     ┌─────▼─────┐     ┌─────────┐     ┌─────────┐  │
 │ Channels  │     │  Message   │     │  Claude  │     │  Tools  │  │
 │           │────▶│  Queue     │────▶│  (LLM)   │────▶│         │──┘
 │ Telegram  │     └───────────┘     └────┬─────┘     └────┬────┘
 │ WebSocket │◀──────────────────────────-│                │
 └───────────┘        Response            │                │
                                    ┌─────▼────────────────▼────┐
                                    │        Context            │
                                    │  ┌──────────┐ ┌────────┐  │
                                    │  │  Memory   │ │ Skills │  │
                                    │  │ SOUL.md   │ │  OTA   │  │
                                    │  │ USER.md   │ │  CLI   │  │
                                    │  │ MEMORY.md │ │  ...   │  │
                                    │  └──────────┘ └────────┘  │
                                    └───────────────────────────┘
                                          ESP32-S3 Flash
```

You send a message on Telegram. The ESP32-S3 picks it up over WiFi, feeds it into an agent loop — Claude thinks, calls tools, reads memory — and sends the reply back. Everything runs on a single $5 chip with all your data stored locally on flash.

## Quick Start

### What You Need

- An **ESP32-S3 dev board** with 16 MB flash and 8 MB PSRAM (e.g. Xiaozhi AI board, ~$10)
- A **USB Type-C cable**
- A **Telegram bot token** — talk to [@BotFather](https://t.me/BotFather) on Telegram to create one
- An **Anthropic API key** — from [console.anthropic.com](https://console.anthropic.com)

### Install

```bash
# You need ESP-IDF installed first:
# https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/get-started/

git clone https://github.com/memovai/mimiclaw.git
cd mimiclaw

idf.py set-target esp32s3
idf.py build
idf.py -p /dev/ttyACM0 flash monitor
```

### Set Up

After flashing, a serial console appears. Type these commands:

```
mimi> wifi_set YourWiFiName YourWiFiPassword
mimi> set_tg_token 123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
mimi> set_api_key sk-ant-api03-xxxxx
mimi> restart
```

That's it. After restart, find your bot on Telegram and start chatting.

### More Commands

```
mimi> wifi_status          # am I connected?
mimi> set_model claude-sonnet-4-5-20241022   # use a different model
mimi> memory_read          # see what the bot remembers
mimi> heap_info            # how much RAM is free?
mimi> session_list         # list all chat sessions
mimi> session_clear 12345  # wipe a conversation
mimi> restart              # reboot
```

## Memory

MimiClaw stores everything as plain text files you can read and edit:

| File | What it is |
|------|------------|
| `SOUL.md` | The bot's personality — edit this to change how it behaves |
| `USER.md` | Info about you — name, preferences, language |
| `MEMORY.md` | Long-term memory — things the bot should always remember |
| `2026-02-05.md` | Daily notes — what happened today |
| `tg_12345.jsonl` | Chat history — your conversation with the bot |

## Also Included

- **WebSocket gateway** on port 18789 — connect from your LAN with any WebSocket client
- **OTA updates** — flash new firmware over WiFi, no USB needed
- **Dual-core** — network I/O and AI processing run on separate CPU cores

## For Developers

Technical details live in the `docs/` folder:

- **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** — system design, module map, task layout, memory budget, protocols, flash partitions
- **[docs/TODO.md](docs/TODO.md)** — feature gap tracker and roadmap

## License

MIT

## Acknowledgments

Inspired by [OpenClaw](https://github.com/openclaw/openclaw). MimiClaw reimplements the core AI agent architecture for embedded hardware — no Linux, no server, just a $5 chip.
