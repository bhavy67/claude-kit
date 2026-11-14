## 1. The strategy in one picture

```
           ┌──────────────── one codebase (React + TS) ────────────────┐
           │                                                           │
   Website (any browser)  ──►  PWA (installable, offline)  ──►  Play Store app (TWA)
           │                         │                              │
      deploy = live           same deploy = live              same deploy = live
                                                         (rebuild only when the
                                                          Android wrapper changes)
```

### Decision tree — pick the lightest option that works

| Need | Choose | Why |
|---|---|---|
| Website + "install to home screen" + offline | **PWA** | Zero extra code. Always start here. |
| …plus a Google Play listing | **PWA + TWA (Bubblewrap)** | ~1 MB Android shell around your live site. Web deploys update the app instantly, no store review. |
| …plus home-screen widgets, scheduled local notifications, background tasks, deep native APIs | **Capacitor** | Same React code, real native plugins. Each change = new store release. |
| …plus heavy native UI, complex gestures, 3D, offline-first DB sync at scale | **React Native / native** | Only when the web genuinely can't. Months, not days. |
| iOS App Store | **Capacitor** (TWA is Android-only) | Apple rejects thin web wrappers without native value — plan real native features. |

**MUST:** Build the PWA first and make it excellent. Every later option wraps it; a weak PWA makes a weak app.

---
