# SquareCatalog

UIKit app that displays a scrollable list of repositories from the **Square** GitHub organization and shows a details screen for a selected repository.

API used: `https://api.github.com/orgs/square/repos`

## Features

- Scrollable list of Square repositories
- Custom `UITableViewCell`:
  - Repository name + description
  - Language badge (icon + language name)
  - Stats (stars + forks)
  - Card-style UI (rounded corners, shadow, spacing)
- Loading & failure handling:
  - Custom animated loading overlay
  - Error alert with Retry
- Pull-to-refresh
- Details screen:
  - Large title
  - Description + extra metadata
  - Button “Open on GitHub”
  - Safari opening is triggered from ViewModel via routing and handled by Coordinator
- Code-only UI (no storyboards for app UI; LaunchScreen storyboard remains)

## Architecture

The project uses a **MVVM + Coordinator + Builder** approach.

### Layers / responsibilities

- **View (UIKit ViewControllers / Views)**
  - Owns layout and rendering of `State`
  - Sends user events to ViewModel using `dispatch(action:)`
  - Does not perform navigation directly

- **ViewModel**
  - Holds `State` and exposes it via `@Published`
  - Executes business logic (load repos, refresh, handle errors)
  - Emits navigation intents via `routing(segue)`

- **Coordinator (XCoordinator)**
  - Owns navigation state and performs transitions using `perform(to:)`
  - Converts ViewModel `Segue` events into `Route` transitions (`push`, `present`, `set`, etc.)

- **Builder**
  - Assembles module dependencies (View + ViewModel + routing closure)
  - Calls `bind(to:)` to connect View and ViewModel

### State / Action / Segue

Each screen follows a typed contract:
- `State`: UI data + flags (loading, refreshing, errorMessage, etc.)
- `Action`: user/intents from the view
- `Segue`: navigation intents emitted by the ViewModel
- Coordinator maps `Segue` → `Route`

## Networking

- `GitHubAPIClient` uses `URLSession` + `async/await`
- Handles:
  - HTTP status validation (non-2xx treated as error)
  - JSON decoding into models
  - Basic headers (`Accept`, `User-Agent`)

## Error handling / Loading

- Initial load and refresh are represented via state flags
- Custom animated overlay is shown while loading
- Errors are surfaced via alert with Retry action

## Testing

Unit tests focus on ViewModels (highest value, deterministic):
- `ReposListViewModel`:
  - success path sets repos and stops loading
  - failure path sets error and stops loading
- `RepoDetailsViewModel`:
  - open GitHub action triggers routing with correct URL
