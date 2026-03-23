# InsurFlow (`smart_sure`)

A **Flutter** web/desktop/mobile-ready insurance agency dashboard (**InsurFlow**) with a clean SaaS-style UI. The app uses **GetX** for routing, dependency injection, and reactive state. Data is currently **mock/dummy** for prototyping—ready to be wired to a real API later.

---

## Features

| Area | Description |
|------|-------------|
| **Dashboard** | Welcome header, support tickets card, upcoming policies, bookmarks, announcements, news, cross-sell widgets |
| **Customers** | Customer list, detail panel, customer create/edit side panel, policy table, add-policy drawer, policy files dialog |
| **Policies** | Full policies list with filters (search, company, type, status, remaining days), data table, row actions |
| **Tickets** | Support tickets with filters, status/assignee/date, create-ticket side panel (shared with home), urgency pills |
| **Users** | User management table, roles (Admin/User), status pills, add/edit user right drawer |
| **Settings** | Tabbed settings: professions, customer statuses & colors, tags, insurance companies & policy types (dual column), dynamic policy fields per policy type, bookmarks (with external links), announcements |

---

## Tech Stack

- **Flutter** (SDK `^3.7.2`)
- **GetX** (`get`) — routing (`GetMaterialApp`), `Bindings`, `Obx` / reactive lists
- **intl** — Turkish date/number formatting where used
- **url_launcher** — opening bookmark URLs from Settings

---

## Project Structure (high level)

```
lib/
├── main.dart                 # App entry, optional global services (e.g. TicketsController)
├── routes/
│   ├── app_routes.dart       # Route name constants
│   └── app_pages.dart        # GetPage definitions
├── app/
│   ├── core/                 # Theme, colors, text styles, layout (e.g. TopNavBar), utils
│   ├── data/
│   │   ├── models/           # Domain models (Policy, Customer, Ticket, User, Settings, …)
│   │   └── dummy/            # Shared seed data where applicable
│   └── modules/
│       ├── home/
│       ├── customers/
│       ├── policies/
│       ├── tickets/
│       ├── users/
│       └── settings/
```

Each feature module typically contains:

- `controllers/` — GetX controllers
- `bindings/` — `Bindings` classes for `GetPage`
- `views/` — Screens and reusable widgets

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel recommended)
- Dart SDK (bundled with Flutter)

### Install dependencies

```bash
cd smart_sure
flutter pub get
```

### Run the app

```bash
flutter run
```

Target a specific device, for example:

```bash
flutter run -d chrome          # Web
flutter run -d macos         # macOS desktop
flutter run -d <device_id>    # iOS/Android (see `flutter devices`)
```

### Analyze & tests

```bash
dart analyze
flutter test
```

---

## Routing

Defined in `lib/routes/app_pages.dart` and `lib/routes/app_routes.dart`. Main routes include:

| Route | Module |
|-------|--------|
| `/home` | Dashboard |
| `/customers` | Customers |
| `/policies` | Policies |
| `/claims` | Tickets (support requests) |
| `/users` | Users |
| `/settings` | Settings |

The top navigation bar (`TopNavBar`) navigates with `Get.toNamed(...)`.

---

## Architecture Notes

- **State:** GetX reactive variables (`Rx`, `RxList`, `Rxn`, etc.) and `Obx` for UI updates.
- **Global controllers:** Example: `TicketsController` may be registered in `main.dart` so the home dashboard and tickets screen share ticket state and the create-ticket drawer.
- **Scrollbars:** Tables that use `Scrollbar` are paired with explicit `ScrollController`s to avoid web/layout assertion issues.
- **Dummy data:** Lists and forms are populated with sample data for UI/UX validation; replace with repositories and API calls when backend is available.

---

## Localization

`main.dart` initializes `intl` date formatting for `tr_TR`. Further localization (ARB / `flutter_localizations`) can be added when product requirements are set.

---

## Deploy: GitHub Pages (free)

The repo includes [`.github/workflows/deploy_github_pages.yml`](.github/workflows/deploy_github_pages.yml). It builds Flutter web with `--base-href /insur_flow/` (must match your **repository name** on GitHub) and publishes to **GitHub Pages**.

### One-time setup on GitHub

1. Repo → **Settings** → **Pages**
2. Under **Build and deployment** → **Source**: choose **GitHub Actions** (not “Deploy from a branch” unless you prefer that)
3. Push `main` (with the workflow file). **Actions** tab should show a green run
4. After success, the site is at: **`https://hcakil.github.io/insur_flow/`**  
   (If you rename the repo, update `--base-href` in the workflow to `/NEW_REPO_NAME/`)

### Local test (same as CI)

```bash
flutter build web --release --base-href /insur_flow/
# Serve build/web with any static server; paths must match base-href
```

The workflow copies `index.html` → `404.html` so refreshing on a deep route still loads the app (GitHub Pages SPA pattern).

---

## License

This project is private / not published to pub.dev (see `pubspec.yaml` → `publish_to: 'none'`). Add a proper license file if you open-source the repo.

---

## Contributing (internal)

1. Follow existing patterns: one controller per screen where possible, `Bindings` per route, widgets split under `views/widgets/`.
2. Run `dart analyze` before pushing.
3. Keep new models under `lib/app/data/models/` unless generated elsewhere.

---

*Project display name in UI: **InsurFlow** · Package name: **smart_sure***
