## 13. Android app (TWA) playbook

> Prerequisite: the PWA is live on a **custom HTTPS domain** and passes §8.

### Decisions (confirm before generating — permanent)
| Item | Rule |
|---|---|
| Domain | Custom subdomain you own (e.g. `app.yourname.in`). The app is tied to it. |
| Package ID | Reverse domain: `in.yourname.app`. **Cannot change after first upload.** |
| Play account | Personal vs organisation (affects closed-testing rules and the public developer name). |

### Generate the project (non-interactive)
The Bubblewrap CLI's `init` is interactive; drive the library instead:
```js
// scratch dir: npm i @bubblewrap/core
const { TwaManifest, TwaGenerator, ConsoleLog } = require('@bubblewrap/core');
const m = await TwaManifest.fromWebManifest('https://app.example.in/manifest.webmanifest');
m.packageId = 'in.example.app';
m.launcherName = 'AppName';
m.appVersionName = '1.0.0'; m.appVersionCode = 1;
m.enableNotifications = false;                       // true only if you send web push
m.features = { locationDelegation: { enabled: true } }; // if you use geolocation
m.orientation = 'default';
m.minSdkVersion = 24;                                 // Play automatic protection requires ≥ 24
for (const k of ['themeColorDark','navigationColor','navigationColorDark','navigationDividerColor','navigationDividerColorDark']) m[k] = m.themeColor; // defaults are #000000
m.signingKey = { path: './android.keystore', alias: 'appname' };
await new TwaGenerator().createTwaProject('android', m, new ConsoleLog('gen'));
await m.saveToFile('android/twa-manifest.json');
// Write android/manifest-checksum.txt = sha1(twa-manifest.json) so `bubblewrap build` doesn't prompt to regenerate.
```
- **MUST:** `android/.gitignore` → `*.keystore`, `*.jks`, `keystore.properties`, `.gradle/`, `build/`, `local.properties`, `*.apk`, `*.aab`, `*.idsig`.
- **MUST:** `targetSdkVersion` = current Play requirement (check yearly).
- **MUST:** `minSdkVersion` ≥ **24** (Android 7.0). **[lesson]** Bubblewrap defaults to 21, and Play rejects the upload: "Play automatic protection requires a minimum SDK version of 24". Set `m.minSdkVersion = 24` when generating, or edit `twa-manifest.json` + `app/build.gradle` and recompute `manifest-checksum.txt`.

### Toolchain (no admin rights needed)
- Install into `~/.bubblewrap/`: **JDK 17**, **Android cmdline-tools** (`android_sdk/cmdline-tools/latest`), `platforms;android-<target>`, `build-tools;<version Bubblewrap expects>`, `platform-tools` (adb).
- Write `~/.bubblewrap/config.json` → `{ "jdkPath": "~/.bubblewrap/jdk", "androidSdkPath": "~/.bubblewrap/android_sdk" }` (absolute paths) and `android/local.properties` → `sdk.dir=…`.
- **[lesson]** Bubblewrap validates `<sdk>/bin` or `<sdk>/tools` (legacy layout). Add a wrapper script `<sdk>/bin/sdkmanager` that `exec`s `cmdline-tools/latest/bin/sdkmanager` — a folder symlink breaks sdkmanager's classpath.
- **[lesson]** Bubblewrap pins a build-tools version (`BUILD_TOOLS_VERSION` in `@bubblewrap/core`) — install exactly that one.
- **[lesson]** GitHub-hosted downloads (Adoptium JDK, Gradle distributions) can crawl on some networks. Use an alternative (Azul Zulu JDK; a Gradle mirror) **and verify the official SHA-256** before use. Drop the verified Gradle zip into `~/.gradle/wrapper/dists/<name>/<hash>/` — no repo changes.
- Run a **debug build** first (`./gradlew assembleDebug`) to validate the toolchain without the signing key.
- Run `npx @bubblewrap/cli doctor` → must print "valid".

### Signing (human-only step)
```bash
cd android
~/.bubblewrap/jdk/Contents/Home/bin/keytool -genkeypair -v -keystore android.keystore \
  -alias appname -keyalg RSA -keysize 2048 -validity 10000
```
- **MUST:** The owner types the password. Back up the keystore + password in a password manager **immediately**. Lose it → you can never update the app.
- **[lesson]** In Claude Code, `! command` runs in the session; in a normal terminal, drop the `!` (zsh treats it as negation).
- **[lesson]** Paths in instructions are relative to *where the terminal is*. Inside `android/`, it's `git add file`, not `git add android/file`.

### Prove ownership (Digital Asset Links)
1. Upload-key fingerprint: `keytool -list -v -keystore android.keystore -alias appname | grep SHA256:`
2. `public/.well-known/assetlinks.json`:
   ```json
   [{ "relation": ["delegate_permission/common.handle_all_urls"],
      "target": { "namespace": "android_app", "package_name": "in.example.app",
                  "sha256_cert_fingerprints": ["<UPLOAD KEY SHA256>", "<PLAY APP SIGNING SHA256>"] } }]
   ```
3. **Deploy to the production domain** (preview URLs don't count). Verify it returns JSON, not your SPA HTML.
4. After the first Play upload, add Google's **App signing key** fingerprint (Play Console → App integrity). Without both, the Play-installed app shows a browser bar.

### Build & test
```bash
cd android && npx @bubblewrap/cli build --skipPwaValidation
# → app-release-bundle.aab (Play) + app-release-signed.apk (phone)
```
Install the APK (send to phone or `adb install`) and verify:
- [ ] No browser bar (after assetlinks is live)
- [ ] Location prompt is Android's own and works
- [ ] Airplane mode → app still works
- [ ] Back button walks screens, then exits
- [ ] Shared links (`https://app.example.in/path?x=y`) open in the app
- [ ] Long-press icon shows shortcuts
- [ ] Status/nav bar colours match the app

---
