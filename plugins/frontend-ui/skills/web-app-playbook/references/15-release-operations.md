## 15. Release & operations

- **Web change** → deploy → website, installed PWA, and Play app all update. No store review.
- **Android wrapper change** (package config, colours, permissions, shortcuts, SDK target) → bump `appVersionCode` (+ `appVersionName`) in `twa-manifest.json` → rebuild → upload. Commit: `Release Android 1.0.1`.
- **Bad build stuck on phones** → bump the cache epoch → deploy.
- **SHOULD:** Show the data/timetable effective date in the app (About sheet + footer) and flag unverified sources honestly.
- **SHOULD:** Build stamp (version · build id · cache epoch) in the About sheet for bug reports.

---
