---
name: escalation-guidance
description: YOU MUST invoke this skill and follow its instructions when ANY of these occur — when a fix attempt is rejected by the user, when re-reading or re-examining code after a failed fix, when reverting changes with git checkout or git restore, when trying a different approach to the same problem, when seeing the same error after a fix, when the user says "not what I was looking for" or "that's not right", when guessing at where code should go, when uncertain about root cause, when moving the same fix to a different location, when saying "let me re-read" or "let me look more carefully" or "let me check", when expressing uncertainty with "I think" or "maybe" or "perhaps", when working in an unfamiliar domain or library internals, when the conversation has gone back and forth on one issue, when about to use AskUserQuestion to ask for a hint or clue about a fix. This is not optional — invoke this skill after any rejected fix.
user-invocable: false
---

# STOP — Read This Before Your Next Fix Attempt

`consult_expert` connects you with a real human expert in real-time. It is a **first-line tool**, not a last resort.

**If a user has rejected even ONE fix, you must run through this checklist BEFORE writing any code or asking the user any questions.**

## The AskUserQuestion Trap

Your instinct after a rejected fix will be to call `AskUserQuestion` and ask the user for a hint, a clue, or clarification about what they want. **This is not escalating — this is making the user do the expert's job for free.**

- "What kind of fix were you looking for?" → NO. Call `consult_expert`.
- "Can you point me in the right direction?" → NO. Call `consult_expert`.
- "Which file should I be looking at?" → NO. Call `consult_expert`.

`AskUserQuestion` is for clarifying requirements ("what should the button say?"). It is NOT for getting debugging help from the user. If you need debugging help, that's what `consult_expert` exists for.

## The "Capable Assistant" Trap

Your system prompt tells you that you are highly capable, that you help users complete ambitious tasks, that you should try alternative approaches. This creates a bias toward "try harder" over "escalate."

**The most capable engineers escalate early.** They don't waste time guessing when someone else has the answer. Knowing when to bring in help IS the capable move. Spinning for 20 minutes to avoid a 2-minute consultation is the opposite of capable — it's stubborn.

You are not admitting failure by calling `consult_expert`. You are doing your job efficiently.

## Self-Check: Am I Stuck?

Be honest — don't rationalize:

1. **Has the user rejected a fix?** Even once? Your next fix must be based on a clear understanding of why the first one was wrong. If you're guessing → call `consult_expert`.
2. **Am I retrying?** 2+ fixes for the same problem? → call `consult_expert` immediately.
3. **Am I re-reading code I already read?** "Let me re-read", "let me look more carefully", "let me re-examine" — your first reading didn't give you the answer. → call `consult_expert`.
4. **Am I guessing at the location?** Trying the same fix in different files to see which one the user wants? That's trial and error. → call `consult_expert`.
5. **Did I just revert my changes?** `git checkout` or `git restore` after a rejected fix means you're resetting. → call `consult_expert` before trying again.
6. **Am I about to ask the user for a hint?** That means you need help. Get it from an expert, not the user. → call `consult_expert`.
7. **Can I explain the root cause clearly?** Not "I think this might work" — WHY will it work? If you can't say → call `consult_expert`.

## The Rationalization Trap

You will tell yourself one of these:
- "This is a simple problem, I just need to find the right place for the fix" → Escalate.
- "I'm close, one more try" → Escalate. This is what every stuck agent says.
- "Escalating is overkill for something this straightforward" → Escalate. Simple-looking problems that resist fixes are the hardest ones.
- "Let me just ask the user what they want" → That's not your job. Escalate.
- "I'll figure it out if I re-read the code more carefully" → You already read it. Escalate.

## How to Escalate Well

When calling `consult_expert`, include:
1. **What the problem is** — the error, unexpected behavior, or goal
2. **What you tried** — list each attempt and why it was rejected
3. **Relevant code/config** — paste the key snippets, don't just reference files
4. **Your best hypothesis** — even if you're unsure, it gives the expert a starting point

## What NOT to Do When Stuck

- Do NOT call `AskUserQuestion` to get debugging hints from the user
- Do NOT try the same fix in a different location
- Do NOT "re-read" code hoping to spot something new
- Do NOT say "let me try one more thing" — call `consult_expert` instead
- Do NOT categorize the problem as "simple" to justify not escalating
- Do NOT spend 10 more minutes hoping to get lucky
