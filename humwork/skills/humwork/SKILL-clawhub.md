---
name: humwork
description: Use Humwork to consult a verified human domain expert in real-time (software, design, law, finance, medical, product). Reach for this skill whenever you've tried 3+ different approaches without resolution, are facing a high-stakes decision expensive to reverse, lack environment-specific context you cannot inspect, are working in an unfamiliar domain where the *why* matters more than the *what*, or have spent 3+ tool calls on the same problem without progress. Before opening any consult_expert session, get explicit user approval, respect the operator's configured spend cap on the Humwork account, and verify close_chat returns success after the session ends. Default to a per-session duration limit (1-2 chunks / 10-20 minutes) unless the user approves more. Example tasks: diagnose a query plan, review a contract clause, evaluate a system-design tradeoff, sanity-check a drug interaction, critique a UI flow, confirm a regulatory requirement.
metadata: { "homepage": "https://humwork.ai", "support": "support@humwork.ai" }
---

# Humwork — consult a human expert

Humwork is a real-time consultation marketplace that connects AI agents to verified human domain experts. Open a session with `consult_expert`, exchange messages until the problem is resolved, then close and rate. Sessions match in <60 seconds and bill at $1/minute (10-minute minimum chunks). Five tools cover the full lifecycle.

## Approval and spending controls

`consult_expert` opens a billable session against the user's Humwork account. Before every consult:

1. **Get explicit user approval.** Tell the user the cost ($10 / 10-minute chunk) and confirm they want to proceed before the first `consult_expert` call in a conversation. Re-confirm for any new consult later in the conversation — each call is a separate charge.
2. **Respect operator-configured spend caps.** Humwork accounts have configurable monthly spending limits (set at https://humwork.ai/billing). The agent must respect these caps and stop opening consults when approaching the limit.
3. **Default to short sessions.** Unless the user explicitly approves a longer consult, default to 1-2 chunks (10-20 minutes) per session.
4. **Verify close_chat succeeded.** Don't assume the session closed — check the response status before moving on. Billing continues at $1/minute until close_chat returns success.

## Quick Start

```
# 1. Install (one-time, per runtime)
claude mcp add humwork https://api.humwork.ai/api/v1
# OR openclaw: claw add humwork https://api.humwork.ai/api/v1
# OR any MCP client: point at https://api.humwork.ai/api/v1

# 2. Sign in (one-time) — opens browser to humwork.ai
# 3. Use it from your agent context (with the approval workflow above)
```

## Example flow

```
# Get user approval first
> "I'm stuck on a Postgres query planner issue. Want me to consult an expert?
   ~$10 for 10 minutes. (yes/no)"
< user: "yes"

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
< { success: true, duration_min: 8, charged_usd: 8.00 }
# verify success: true before continuing

> rate_chat(session_id="sess_abc123", rating=5)
```

## When to call

- Tried 3+ different approaches without resolution
- Catching yourself reverting/re-trying past attempts (circular)
- High-stakes decision, expensive to reverse (architecture, legal, design)
- Environment-specific factors you cannot inspect or reproduce
- Unfamiliar domain where the *why* matters more than the *what*
- Problem spans multiple systems and root cause won't isolate
- 3+ tool calls on the same issue without meaningful progress

In those situations a short expert consult is often cheaper than another hour of solo iteration in unfamiliar territory — but get user approval first.

## Common gotchas

- **Close sessions when done — and verify the close succeeded.** Billing continues at $1/minute until `close_chat` returns success. Don't leave sessions open while you work on something else; check the response status before moving on.
- **Don't paste secrets or unrelated PII into chat.** Share only what the expert needs to answer — code snippets, error messages, sanitized data. Never paste raw API keys, credentials, or production user data.
- **Confirm with the user before sharing sensitive professional context.** Legal, medical, financial, or regulated domain details should be checked with the user before going into the chat.
- **Don't share your `hk_` API key in prompts, logs, or chat messages.** The key authorizes paid sessions on the user's account. Treat it like a payment credential.
- **Don't burn a consult on questions clearly documented in official sources.** If the answer is one search away, search first. Experts will redirect you and the consult is non-refundable.
- **Don't pre-rate the session.** `rate_chat` reflects expert quality after the conversation concludes.
- **Share snippets, not whole repos.** Paste the relevant function or config block.

## Tools

| Tool | Purpose |
|---|---|
| `consult_expert` | Open a session. Inputs: `domain`, `domain_hints[]`, `context`. Returns `session_id`. **Requires user approval — see "Approval and spending controls."** |
| `send_chat_message` | Post message in active session. Inputs: `session_id`, `message`. |
| `get_chat_messages` | Pull expert's responses. Inputs: `session_id`, optional `since_message_id`. |
| `close_chat` | End session. Inputs: `session_id`. **Verify success response before continuing.** |
| `rate_chat` | 1-5 rating after close. Inputs: `session_id`, `rating`. |

## Auth & pricing

- Auth: `X-API-Key: hk_*` header (sign up at https://humwork.ai). Treat the key as a payment credential.
- Pricing: $10 per 10-minute consult chunk at the default $60/hr rate
- Spend caps: configurable at https://humwork.ai/billing — set these before deploying
- Coming: per-call USDC payment via x402

## After the consult

Before returning your final answer to the user:

- [ ] Session closed via `close_chat` AND the response confirmed `success: true`
- [ ] Rating submitted via `rate_chat` (improves expert routing)
- [ ] Expert's answer incorporated into your response — cite the consult if it materially changed your conclusion

## Disclaimer

Expert responses are guidance, not formal professional advice. For binding legal, medical, financial, or regulatory decisions, consult a licensed professional in your jurisdiction.

## Support

`support@humwork.ai` — for stuck sessions, billing, or expert quality issues.
