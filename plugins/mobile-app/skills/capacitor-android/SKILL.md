---
name: capacitor-android
description: Wrap a web app in Capacitor for Android/iOS and avoid WebView traps: storage that gets wiped, file downloads, notifications, biometric lock, R8/proguard in release builds, command-line builds. Use when adding Capacitor, debugging native-only bugs, or preparing a Play Store release.
---

# Capacitor (Android first)

For the TWA route and the Play launch checklist see `frontend-ui:web-app-playbook` (sections 13-14). This skill covers the Capacitor path and what only breaks on a device.

## Setup
- App id is **permanent after the first store upload** (e.g. `in.yourname.app`). Decide it once.
- `cap sync` = web build + copy output into `android/` and `ios/`. A static web export is the simplest input (see `frontend-ui:frontend-gotchas`).
- Build without Android Studio: JDK 21 + Android command-line tools, then `cd android && ./gradlew assembleDebug`. Create an emulator AVD with `sdkmanager` and `avdmanager`.
- Icons and splash: keep source art in `assets/`, generate with `npx @capacitor/assets generate --android`.
- Debug builds expose the WebView to Chrome DevTools. Playwright's `_android` API can drive it (pick the page with body text; Capacitor also exposes an empty one).

## Storage and files
- **Never write `localStorage` directly.** The OS may wipe WebView storage. Wrap writes in a helper that mirrors each write to the app data directory and restores at boot. Make the data layer wait for the restore; any code reading storage at mount outside it must `await` the restore too.
- Store file blobs in the app data dir on native; IndexedDB is for web only.
- **`<a download>` and `target="_blank"` on blob URLs do nothing in a WebView.** Use a `saveFile` helper: share sheet on native, normal download on web.
- Prerendered HTML is built with `isNative = false`. Branching rendered output on it causes a hydration mismatch on the phone. Branch inside handlers and effects.
- Native servers map extensionless paths to the root `index.html`, so a hard reload on a deep route boots the landing page. Client-side navigation is unaffected; design the landing page to redirect sensibly.

## Features
- **App lock** (biometric/PIN) is a convenience gate, not encryption. Re-lock after a grace period in the background, because the share sheet and the biometric prompt also pause the activity. Reset the "left at" timestamp on every return, or a successful unlock re-locks immediately.
- **Local notifications:** pass `isExactNotification: false`. Exact alarms need `SCHEDULE_EXACT_ALARM`; without it the plugin sends the user to a settings page and `schedule()` hangs. Don't request that permission unless the product truly needs exact times.

## Release builds
- Enable R8 (`minifyEnabled true`); Play flags unobfuscated code. **R8 bugs exist only in release**, so test every plugin on a signed release APK before upload.
- Keep Capacitor annotations in `proguard-rules.pro`: `-keep @interface com.getcapacitor.annotation.**`. Without it R8 full mode drops `@CapacitorPlugin(permissions=…)` data; `checkPermissions()` resolves empty and `requestPermissions()` hangs with no dialog.
- Bump `versionCode` every upload; keep the signing keystore and its passwords backed up outside the repo. Losing it means you can't update the app (unless using Play App Signing, which you should).
