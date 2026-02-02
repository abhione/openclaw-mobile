# OpenClaw Mobile 📱

A native iOS companion app for [OpenClaw](https://github.com/openclaw) — the open-source AI agent platform.

Chat with your AI agent, browse your knowledge graph, and track tasks — all from your phone.

## Features

### 💬 Chat
Converse with your OpenClaw agent in a clean, native chat interface. Messages are sent through the OpenClaw Gateway REST API with full session support.

### ✅ Tasks
View and track tasks from your knowledge graph. Filter by status (in progress, pending, completed, blocked), see linked entities, and drill into task details.

### 🔗 Knowledge Graph
Browse entities (people, companies, projects), view facts, relationships, events, and connected tasks. Full-text search across your knowledge base.

### ⚙️ Settings
Configure your Gateway URL and token, Knowledge Graph API endpoint, test connections, and view agent status at a glance.

## Screenshots

*Coming soon*

## Requirements

- iOS 18.0+
- Xcode 16+
- Swift 6.2
- An OpenClaw Gateway instance (for chat)
- Knowledge Graph API sidecar (optional, for entities/tasks/graph)

## Setup

1. **Open** the project in Xcode or build via Swift Package Manager
2. **Run** on your device or simulator
3. **Go to Settings** tab
4. **Enter** your OpenClaw Gateway URL (e.g., `https://your-gateway.example.com`)
5. **Enter** your Gateway bearer token
6. *(Optional)* Enter your Knowledge Graph API URL (e.g., `http://localhost:18790`)
7. **Tap** "Test Connections" to verify

## Architecture

```
┌──────────────────┐     ┌──────────────────────┐
│  OpenClaw Mobile │────▶│  OpenClaw Gateway     │
│  (iOS App)       │     │  REST API             │
└──────────────────┘     └──────────────────────┘
        │
        │  (optional)
        ▼
┌──────────────────────┐
│  Knowledge Graph API │
│  Sidecar (:18790)    │
└──────────────────────┘
```

### Gateway API Endpoints
- `POST /api/sessions/{key}/message` — Send a chat message
- `GET /api/sessions/{key}/history` — Message history
- `GET /api/sessions` — List sessions
- `GET /api/status` — Gateway status

### Knowledge Graph API Endpoints
- `GET /api/entities` — List entities (with optional `?type=` filter)
- `GET /api/entity/{name}` — Entity profile with facts, relationships, events
- `GET /api/tasks` — List tasks (with optional `?status=` filter)
- `GET /api/search?q=` — Full-text search
- `GET /api/relationships?entity=` — Entity relationships
- `GET /api/graph` — Full graph data
- `GET /api/stats` — Database statistics

### Project Structure

```
Sources/OpenClawMobile/
├── App/          → Entry point, tab-based navigation
├── Models/       → Codable data models (Entity, Task, Message, GraphData)
├── Services/     → API clients (GatewayService, KnowledgeGraphService, Configuration)
├── Views/        → SwiftUI views organized by feature
│   ├── Chat/     → Chat interface with message bubbles
│   ├── Tasks/    → Task list, filters, and detail view
│   ├── Graph/    → Entity browser, search, and detail profiles
│   ├── Settings/ → Configuration and connection testing
│   └── Components/ → Reusable UI components
└── Theme/        → Colors, fonts, and styling constants
```

## Tech Stack

- **SwiftUI** — Declarative UI framework
- **Swift Concurrency** — async/await for all network calls
- **URLSession** — Native HTTP client
- **@AppStorage** — Persistent configuration
- **@EnvironmentObject** — Shared state management

## Design

Dark theme inspired by the OpenClaw brand:
- **Background:** Dark navy (`#0a0f1a`)
- **Cards:** Slightly lighter (`#141b2d`)
- **Accent:** Electric blue (`#3b82f6`)
- **Status colors:** Green (completed), Blue (in progress), Yellow (pending), Red (blocked)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Guidelines
- Follow Swift naming conventions and SwiftUI best practices
- Use `async/await` for all asynchronous work
- Keep views small and composable
- Add previews for all views
- Test on both iPhone and iPad

## License

MIT License — see [LICENSE](LICENSE) for details.

---

Built with ❤️ for the OpenClaw community.
