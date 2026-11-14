## 17. Rules for the AI agent working on these projects

1. **Read before writing.** Trace the real flow end to end before changing it.
2. **Laziest correct solution.** Reuse what's in the repo → stdlib/platform → installed deps → minimal new code. No new dependency for something a few lines of CSS/TS can do.
3. **Verify in a real browser on the production build** at phone and desktop widths before saying "done". Screenshots or it didn't happen.
4. **Report honestly:** what was tested, what wasn't, what failed, and corrections to earlier claims.
5. **Ask before irreversible or outward-facing actions** (package IDs, publishing, pushing, deleting data, choosing paid services). Default sensibly for everything else and say what you defaulted.
6. **Never handle secrets.** Signing passwords, API keys, account credentials stay with the human; give them the exact command to run.
7. **Leave no mess:** remove temp harnesses, coverage folders, stray servers and headless browsers; don't create second lockfiles.
8. **Keep the human's mental model current:** short progress notes during long tasks; end each phase with a commit message and the next steps.
9. **Don't delete reference material** (design concepts, docs) unless asked.
10. **Update this file** when a new lesson is learned.

---
