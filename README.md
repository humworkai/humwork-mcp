# Humwork MCP Plugin

Connect AI agents with human experts in real-time. When your AI assistant gets stuck, Humwork matches it with a verified domain expert who diagnoses the problem and provides solutions — all within the agent's context.

## Installation

### Claude Code

```bash
claude mcp add --transport http humwork https://api.humwork.ai/api/v1
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

**Authentication:** Run `/mcp`, select **humwork**, click **Re-authenticate**, and sign in at [humwork.ai](https://humwork.ai). Auth lasts 30 days.

---

### Cursor

Add to your project's `.cursor/mcp.json` (or global `~/.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "humwork": {
      "url": "https://api.humwork.ai/api/v1",
      "headers": {
        "X-API-Key": "YOUR_API_KEY"
      }
    }
  }
}
```

Or: **Settings** (Cmd+Shift+J) → **MCP** → **Add new MCP Server** → paste the config above.

Get your API key from your [Humwork dashboard](https://humwork.ai/dashboard).

---

### OpenAI Codex CLI

Add to `~/.codex/config.toml` (or `.codex/config.toml` in your project):

```toml
[mcp_servers.humwork]
type = "http"
url = "https://api.humwork.ai/api/v1"

[mcp_servers.humwork.http_headers]
X-API-Key = "YOUR_API_KEY"
```

Get your API key from your [Humwork dashboard](https://humwork.ai/dashboard).

---

### ChatGPT

1. In ChatGPT, go to **Explore GPTs** or the **Plugin Store**
2. Search for **Humwork** and click **Install**
3. Authorize with your Humwork account

---

### Windsurf

Add the MCP server in Windsurf settings:

```json
{
  "mcpServers": {
    "humwork": {
      "url": "https://api.humwork.ai/api/v1",
      "headers": {
        "X-API-Key": "YOUR_API_KEY"
      }
    }
  }
}
```

Or: **Settings** → **MCP / Plugins** → **Add MCP Server** → paste the config above.

Get your API key from your [Humwork dashboard](https://humwork.ai/dashboard).

---

### Lovable

1. Open **Settings** → **Connectors** → **Personal connectors**
2. Click **New MCP server**
3. Name: `humwork`, Server URL: `https://api.humwork.ai/api/v1`
4. Authenticate with your Humwork account when prompted

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
- **Platform configs** (`configs/`) — ready-to-use configs for Cursor, Codex, Windsurf, and Lovable
- **Hooks** (`hooks/`) — behavioral hooks that teach agents when to escalate
- **Skills** (`skills/`) — guidance that helps agents escalate effectively
- **Commands** (`commands/`) — setup instructions for authentication

## Links

- [Humwork](https://humwork.ai) — Homepage
- [Documentation](https://humwork.ai/docs) — Full docs

## License

MIT
