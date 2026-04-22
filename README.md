# Humwork MCP Plugin

Connect AI agents with verified domain experts in real-time. When your AI agent needs human expertise — for debugging, architecture decisions, or unfamiliar domains — Humwork matches it with a specialist who diagnoses the problem and provides solutions, all within the agent's context.

## Installation

### Claude Code

#### Plugin

Inside Claude Code, run:

```bash
/plugin marketplace add humworkai/humwork-mcp
```

Then install the plugin:

```bash
/plugin install humwork@humwork-mcp
```

Finally, run `/mcp`, select **humwork**, click **Re-authenticate**, and sign in at [humwork.ai](https://humwork.ai). Auth lasts 30 days.

#### MCP

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

### Claude.ai (Web)

1. Go to [claude.ai/customize/connectors](https://claude.ai/customize/connectors)
2. Click the **+** button to add a custom connector
3. Fill in:
   - **Name:** `Humwork`
   - **Remote MCP server URL:** `https://api.humwork.ai/api/v1`
4. Click **Add** — a browser window will open to authenticate with your Humwork account
5. Once connected, set tool permissions to **Always allow** or **Needs approval** as preferred

All 6 tools will be available: `consult_expert`, `send_chat_message`, `get_chat_messages`, `extend_session`, `close_chat`, and `rate_chat`.

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

Requires **Node.js 18+** (the bridge runs via `npx`). Check with `node --version`, install with `brew install node` if needed.

Add to `~/.codex/config.toml` (or `.codex/config.toml` in your project):

```toml
[mcp_servers.humwork]
command = "npx"
args = [
  "-y",
  "mcp-remote@latest",
  "https://api.humwork.ai/api/v1",
  "--header",
  "X-API-Key:${HUMWORK_API_KEY}"
]

[mcp_servers.humwork.env]
HUMWORK_API_KEY = "YOUR_API_KEY"
```

Get your API key from your [Humwork dashboard](https://humwork.ai/dashboard).

---

### ChatGPT

Requires ChatGPT **Plus, Pro, Business, or Enterprise** — custom apps are not available on the free tier.

1. Go to **Settings → Apps → Advanced** and toggle **Developer mode** on. Accept the "Elevated Risk" warning.
2. Back on the Apps page, click **Create app** (top right).
3. Fill in:
   - **Name:** `Humwork`
   - **MCP Server URL:** `https://api.humwork.ai/api/v1/gpt`
   - **Authentication:** `OAuth`
   - Check **"I understand and want to continue"** and click **Create**.
4. A browser window will open — sign in with your Humwork account to authorize.

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

---

### OpenClaw

Requires **OpenClaw 2026.4+** and **Node.js 22+**. Install with `npm install -g openclaw@latest` if needed.

1. Add Humwork as an MCP server:

```bash
openclaw mcp set humwork '{"url":"https://api.humwork.ai/api/v1","transport":"streamable-http","headers":{"X-API-Key":"YOUR_API_KEY"}}'
```

2. Restart the gateway to pick up the config:

```bash
openclaw gateway stop && openclaw gateway
```

3. Verify and open the dashboard:

```bash
openclaw mcp list
openclaw dashboard
```

Get your API key from your [Humwork dashboard](https://humwork.ai/dashboard).

> **Note:** OpenClaw requires a model provider API key configured separately. Run `openclaw models auth paste-token --provider anthropic` to add your Anthropic key.

## Available Tools

| Tool | Description |
|------|-------------|
| `consult_expert` | Start a consultation with a matched expert. Describe the problem, what you've tried, and relevant context. |
| `send_chat_message` | Send a follow-up message in an active expert chat session. |
| `get_chat_messages` | Retrieve messages from an expert chat session. |
| `close_chat` | Close a chat session when the problem is resolved. Optionally include a rating (1-5). |
| `rate_chat` | Rate an expert's helpfulness (1-5) after a chat session closes. Must be submitted within 15 minutes. |

## How It Works

1. Your AI agent identifies a need for expert guidance (repeated failures, architectural decisions, unfamiliar domains)
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
