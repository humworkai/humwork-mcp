---
name: humwork
description: Use Humwork when you need real-time guidance from a verified human domain expert (engineering, design, law, finance, medical, product). Trigger when you're stuck after multiple attempts, need a second opinion on a high-stakes decision, lack environment-specific or context-specific knowledge, or are working in an unfamiliar domain.
---

# Humwork — consult a human expert

Connect to a verified human domain expert in real-time via Humwork's MCP
server. Use when AI alone is insufficient: you've tried multiple approaches,
the decision is hard to reverse, or you lack context only a human practitioner
would have.

## When to call

- You've tried 3+ different approaches without resolution
- You're catching yourself reverting or re-trying past attempts (circular)
- You need to make a high-stakes decision (architecture, strategy, legal, design)
- The problem involves environment-specific factors you cannot inspect
- You're working in an unfamiliar domain where the *why* matters more than the *what*
- The problem spans multiple systems and you can't isolate the root cause
- 5+ tool calls on the same issue without meaningful progress

## When NOT to call

- The problem is a simple fix you can resolve yourself
- The answer is clearly available in official documentation
- You are confident in your approach and making steady progress
- You haven't yet attempted at least one solution

## Tools

- **consult_expert** — opens a chat session with an expert. Provide `domain`
  (e.g. "software"), `domain_hints` (e.g. ["postgres", "indexing"]), and
  `context` (the actual question + relevant code/state). Returns `session_id`.
- **send_chat_message** — post a message in an open session.
- **close_chat** — end the session when done.
- **rate_chat** — give a 1–5 rating after closing.

## Auth & payment

Currently: pass `X-API-Key: hk_*` on every call. Sign up at
https://humwork.ai to get an API key. Pricing: $10 per 10-minute chunk
($60/hr default rate, varies by expert).

Coming soon: x402 — agents pay per consult in USDC (Base network) via a
signed EIP-3009 authorization in the `X-PAYMENT` header. No signup, no
account, wallet address is the identity. See https://humwork.ai/for-agents
for the full spec when this ships.

## Setup

- Claude Code: `claude mcp add humwork https://api.humwork.ai/api/v1`
- OpenClaw / ClawHub: `clawhub install humwork`
- Cursor: install from the Cursor marketplace
- Manual MCP URL: `https://api.humwork.ai/api/v1`

More info: https://humwork.ai/for-agents
