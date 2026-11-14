---
name: web-app-playbook
description: Opinionated rulebook for building and shipping a mobile-first web app or PWA: stack, structure, architecture, mobile UX, PWA, security, performance budgets, testing, Android TWA and Play launch, git and release. Use when starting a web app, scoping a phase, or checking work against a definition of done.
---

# Web app playbook

A rulebook split into small files so only the relevant part is read. Do not read them all. Pick by task, read that file, apply it. If the project's own docs disagree, the project wins.

| If the task is… | Read (in `references/`) |
|---|---|
| Starting a project, choosing approach | `01-the-strategy-in-one-picture.md`, `02-non-negotiables-the-short-list.md`, `03-default-stack.md` |
| Laying out folders or modules | `04-project-structure.md`, `05-architecture-rules.md` |
| Building screens for phones | `06-mobile-ux-rules.md` |
| Colors, type, spacing, components | `07-design-system-rules.md` (and the `ui-design-system` skill) |
| Offline, install, service worker | `08-pwa-rules.md` |
| Adding an analytics, auth, payments or other third-party service | `09-third-party-services.md` |
| Auth, data handling, privacy, headers | `10-security-privacy.md` |
| Speed, bundle size, Core Web Vitals | `11-performance-budgets.md` |
| Tests, QA, release gates | `12-testing-qa.md` |
| Wrapping as an Android app | `13-android-app-twa-playbook.md`, `14-google-play-launch-checklist.md` |
| Releasing and operating | `15-release-operations.md` |
| Branching, commits, PRs, and what an AI agent may do | `16-git-workflow.md`, `17-rules-for-the-ai-agent-working-on-these-.md` |
| Planning phases | `18-phase-map-copy-into-each-new-project-s-r.md` |
| Finishing any PR | `19-definition-of-done-every-pr.md` |

`00-how-to-use-this-file.md` explains the original intent.

## How to apply

1. State which sections you are applying before you build.
2. Where the playbook conflicts with the user's stated request, follow the user and say what you deviated from.
3. When a rule forces a trade-off you disagree with, say so once, with the cost, instead of silently ignoring it.
