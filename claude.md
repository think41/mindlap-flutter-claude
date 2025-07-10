## Purpose
Flutter starter blueprint for **___** (mobile-first, web-friendly).

## Tech Stack
| Concern | Lib | Note |
|---------|-----|------|
| State | `provider` + `ChangeNotifier` | Simple, well-known. Riverpod allowed for advanced cases. |
| Nav | `go_router` | No hard-coded paths. :contentReference[oaicite:6]{index=6} |
| HTTP | `dio` with global interceptors | Centralised error/refresh logic. :contentReference[oaicite:7]{index=7} |
| Storage | `shared_preferences` (simple) / `sqlite` (complex) | :contentReference[oaicite:8]{index=8} |

## Project Layout
`lib/` uses **feature-first** folders. See `/docs/folder-guide.md` for rationale. :contentReference[oaicite:9]{index=9}  

## Quality Gates
- `flutter analyze` passes
- Tests ≥ 80 % line coverage (unit, widget, critical E2E). :contentReference[oaicite:10]{index=10}
- GitHub Actions runs lint + tests per PR

## UX & Accessibility
Material 3, light/dark, min 4.5:1 contrast, semantic labels. :contentReference[oaicite:11]{index=11}  

## Performance Cheatsheet
`const` widgets, `ListView.builder`, image caching, `flutter run --profile` before every release.

## CI/CD
See `.github/workflows/ci.yaml` for build, test, and release steps.

## Security & Compliance
HTTPS only; JWT handled by Dio interceptor; secrets via CI env vars.

