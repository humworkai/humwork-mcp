# Humwork MCP Plugin

Connect AI agents with human experts in real-time. When your AI assistant gets stuck, Humwork matches it with a verified domain expert who diagnoses the problem and provides solutions — all within the agent's context.

## Installation

### Claude Code

```bash
claude mcp add-from-claude-plugin humwork-mcp
```

Or add manually to your project's `.mcp.json`:

```json
{
  "mcpServers": {
    "humwork": {
      "type": "http",
      "url": "https://api.humwork.ai/api/v1"
    }
  }
}
```

### Authentication

1. Run `/mcp` and select **humwork**
2. Click **Re-authenticate** — a browser window will open
3. Sign in or create an account at [humwork.ai](https://humwork.ai)
4. You're all set! Authentication lasts 30 days.

## Available Tools

| Tool | Description |
|------|-------------|
| `consult_expert` | Start a consultation with a matched expert. Describe the problem, what you've tried, and relevant context. |
| `send_chat_message` | Send a follow-up message in an active expert chat session. |
| `get_chat_messages` | Retrieve messages from an expert chat session. |
| `close_chat` | Close a chat session when the problem is resolved. Optionally include a rating (1-5). |
| `rate_chat` | Rate an expert's helpfulness (1-5) after a chat session closes. Must be submitted within 15 minutes. |

## How It Works

1. Your AI agent detects it's stuck (repeated failures, circular debugging, architectural decisions)
2. It calls `consult_expert` with problem details, attempted solutions, and relevant context
3. Humwork matches the request with a verified expert based on domain expertise
4. The expert and agent chat in real-time until the problem is resolved
5. The agent calls `close_chat` to end the session (with an optional rating)
6. If no rating was provided at close, the agent calls `rate_chat` within 15 minutes

## What's Included

- **Plugin manifest** (`.claude-plugin/plugin.json`) — name, version, description
- **MCP server config** (`.mcp.json`) — server URL
- **Hooks** (`hooks/`) — behavioral hooks that teach agents when to escalate
- **Skills** (`skills/`) — guidance that helps agents escalate effectively
- **Commands** (`commands/`) — setup instructions for authentication

## Links

- [Humwork](https://humwork.ai) — Homepage
- [Documentation](https://humwork.ai/docs) — Full docs

## License

MIT
