## 2. Non-negotiables (the short list)

1. **Mobile-first, then scale up.** Design at 390 px; verify at 320 / 390 / 768 / 1024 / 1440 / 1920.
2. **Works offline** for its core job. Network = enhancement.
3. **Test the production build**, never only `dev`. **[lesson]** The live map worked in dev and was completely broken in production (MapLibre's worker file wasn't emitted). Only a prod-build E2E run caught it.
4. **No secrets in the client.** Ever. Anything in the bundle is public.
5. **A privacy page that matches reality** — audit actual network calls and storage before writing it.
6. **Accessibility 100 on Lighthouse/axe** is the floor, not the goal.
7. **Every dependency must earn its bytes.** **[lesson]** An animation library cost 46 KB gzipped for two sliding pills; CSS did it for free.
8. **Decisions that can't be undone get confirmed first:** package/app ID, domain, store publishing, signing keys, data deletion.
9. **Passwords and signing keys never pass through an AI agent or chat.** The human creates and stores them.
10. **One branch per phase, one commit per meaningful step**, simple imperative messages.

---
