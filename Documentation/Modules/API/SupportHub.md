# SupportHub Module Documentation (API — SignalR)

---

## Overview

### Purpose
Real-time support chat hub: connection grouping (per-user + agents + per-conversation) and broadcast helpers.

### Business Objective
Deliver messages live to the right audience: the conversation window, the participating user, and the agent group.

### Main Functionality
- Group users on connect: `user-{id}` + `agents` (for admin/support roles)
- `JoinConversation` / `LeaveConversation` for open chat windows
- Static broadcast helpers used by the REST controllers

### Primary User Roles

| Role | Description |
|------|-------------|
| Authenticated users | Receive their own messages/unread updates |
| Agents (Admin/Support roles) | Agent-group broadcasts |

---

## Module Architecture

```
Presentation           SignalR Hub (/hubs/support) — [Authorize] class
Application            IHubContext<SupportHub> (used by REST controllers)
Groups                 "user-{userId}" · "agents" · "conv-{conversationId}"
```

### Hubs

| Hub | Responsibility |
|-----|----------------|
| `SupportHub` | Connect grouping + conversation join/leave + static broadcast helpers (70 lines) |

### Consumers

| Consumer | Calls | Verified in |
|----------|-------|-------------|
| Learner `SupportController` (API) | `BroadcastNewMessageAsync`, `NotifyAgentsConversationsChangedAsync` | SupportController.cs:62, :96-97 |
| Admin `SupportController` (API) | `BroadcastNewMessageAsync`, `NotifyUserConversationsChangedAsync`, `NotifyAgentsConversationsChangedAsync` | SupportController.cs:86, :113, :115 |

---

## Folder Structure

```
Hubs/
+-- SupportHub.cs                     # 70 lines
```

---

## Connection & Grouping

### Workflow 1: OnConnectedAsync

```mermaid
flowchart TD
    A[Client connects with JWT<br/>token via ?access_token= for /hubs<br/>Program.cs:79-92] --> B[userId = Context.UserIdentifier :20]
    B -->|non-empty| C[Add to group user-{userId} :22]
    C --> D{IsInRole Admin OR Support? :24}
    D -->|yes| E[Add to group agents :26]
    D -->|no| F[Connected]
    E --> F
```

#### Key facts
- Group name `user-{userId}` — scoped by the authenticated user id (SupportHub.cs:20-22).
- Agent detection: `SD.Admin` **or** `SD.Support` role (:24) — note this is the API's `SD.Support` (no trailing space issue here; `SD.Moderator` is NOT granted agent access).

### Workflow 2: Join / Leave Conversation

```mermaid
flowchart TD
    A[Chat window opens] --> B[JoinConversation(conversationId) :34-35]
    B --> C[Group conv-{conversationId}]
    D[Chat window closes] --> E[LeaveConversation :40-41]
    E --> F[Remove from conv-{id}]
```

#### Runtime Behavior
- **`JoinConversation` performs NO ownership check** (SupportHub.cs:34-35) — any authenticated client can subscribe to any `conv-{id}` and receive live messages for conversations they don't own. The REST layer enforces ownership; the hub does not.
- `LeaveConversation` symmetric, also unguarded (:40-41).

---

## Broadcast Helpers (static)

| Helper | Behavior | Verified in |
|--------|----------|-------------|
| `BroadcastNewMessageAsync(hub, message, recipientGroup, unread)` | `ReceiveMessage` → `conv-{message.ConversationId}` group; `UnreadCountChanged` → recipient group (user or agents) | :48-54 |
| `NotifyAgentsConversationsChangedAsync(hub)` | `ConversationsChanged` → `agents` group | :59-60 |
| `NotifyUserConversationsChangedAsync(hub, userId)` | `ConversationsChanged` → `user-{userId}` group | :65-66 |

#### Key facts
- Messages are delivered to the conversation group first (:50), then the recipient's unread count is pushed (:53) — the two-phase delivery the widget relies on.
- All helpers are `static` — called from REST controllers via `IHubContext<SupportHub>` (no hub instance needed).

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Users grouped by own id | :20-22 | Private push channels |
| Agents = Admin/Support roles | :24 | Agent-only broadcasts |
| Message fan-out per conversation | :50 | Live chat windows |

---

## Security Analysis

| Control | Status |
|---------|--------|
| Authentication | ✅ `[Authorize]` class (:15) + query-token for hubs (Program.cs:79-92) |
| **Conversation-group IDOR** | ❌ `JoinConversation` unguarded (:34-35) — any authenticated client joins any `conv-{id}` and receives its messages |
| Group naming | derived from server-side user id / conversation id (no client-supplied group names) |
| Token exposure | query-string token (SignalR standard; visible in browser history/logs) |

---

## Hidden Behaviors & Technical Notes

1. **Critical**: the hub IDOR mirrors the README cross-cutting finding — REST enforces conversation ownership; the hub does not. A malicious client can open any chat window's live stream.
2. **`user-{id}` group is trusted** — server-derived from the JWT; no spoofing via client input.
3. **Moderator role** does NOT join `agents` (only Admin/Support) — check the trailing-space `SD.Moderator` quirk doesn't silently create a second agent path elsewhere.
4. Helpers being static means REST controllers bypass hub instance state entirely — consistent two-way push.

---

## Configuration

| Key | Purpose |
|-----|---------|
| SignalR hub route | `/hubs/support` (Program.cs:245) |

---

## Change Log

**Current functionality (verified):** connection grouping, conversation join/leave, static broadcast helpers — with an unguarded `JoinConversation` IDOR.

**Maintenance notes:** authorize `JoinConversation` against conversation ownership (query the support service inside the hub, or validate before joining).