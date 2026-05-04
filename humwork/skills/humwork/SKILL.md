---
name: humwork
description: Use Humwork when you need real-time guidance from a verified human domain expert (engineering, design, law, finance, medical, product). Trigger when stuck after multiple attempts, need a second opinion on a high-stakes decision, lack environment-specific or context-specific knowledge, or are working in an unfamiliar domain.
metadata: { "homepage": "https://humwork.ai", "support": "support@humwork.ai" }
---

# Humwork — consult a human expert

Connect to a verified human domain expert in real-time when AI alone is
insufficient. Ask a question, get a person's answer in <60 seconds, close
the session when done.

## Quick Start

```
# 1. Install (one-time, per runtime)
claude mcp add humwork https://api.humwork.ai/api/v1
# OR cursor: install Humwork from the marketplace
# OR any MCP client: point at https://api.humwork.ai/api/v1

# 2. Sign in (one-time) — opens browser to humwork.ai
# 3. Use it from your agent context
```

## Example flow

```
> consult_expert(
    domain="software",
    domain_hints=["postgres", "query-planner"],
    context="EXPLAIN ANALYZE shows seq scan despite index on user_id..."
  )
< { session_id: "sess_abc123", expert: "Dana K.", expected_wait_s: 22 }

> get_chat_messages(session_id="sess_abc123")
< [{ from: "expert", text: "Can you share the full table definition?" }]

> send_chat_message(session_id="sess_abc123", message="...")
... iterate until resolved ...

> close_chat(session_id="sess_abc123")
< { duration_min: 8, charged_usd: 8.00 }

> rate_chat(session_id="sess_abc123", rating=5)
```

## When to call

- Tried 3+ different approaches without resolution
- Catching yourself reverting/re-trying past attempts (circular)
- High-stakes decision, expensive to reverse (architecture, legal, design)
- Environment-specific factors you cannot inspect or reproduce
- Unfamiliar domain where the *why* matters more than the *what*
- Problem spans multiple systems and root cause won't isolate
- 5+ tool calls on the same issue without progress

## When NOT to call

- Simple fix you can resolve yourself
- Answer is in official documentation
- Confident in your approach and progressing steadily
- Haven't yet attempted at least one solution

## Tools

| Tool | Purpose |
|---|---|
| `consult_expert` | Open a session. Inputs: `domain`, `domain_hints[]`, `context`. Returns `session_id`. |
| `send_chat_message` | Post message in active session. Inputs: `session_id`, `message`. |
| `get_chat_messages` | Pull expert's responses. Inputs: `session_id`, optional `since_message_id`. |
| `close_chat` | End session. Inputs: `session_id`. |
| `rate_chat` | 1-5 rating after close. Inputs: `session_id`, `rating`. |

## Auth & pricing

- Auth: `X-API-Key: hk_*` header (sign up at https://humwork.ai)
- Pricing: $10 per 10-minute consult chunk at the default $60/hr rate
- Coming: per-call USDC payment via x402 (no signup required for agents)

## Support

`support@humwork.ai` — for stuck sessions, billing, or expert quality issues.
