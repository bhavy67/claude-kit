## 16. Git workflow

- **MUST:** Branch per phase (`feature/<thing>`, `fix/<thing>`); never commit straight to `master` for multi-step work.
- **MUST:** Commit messages: simple, imperative, one line, one per phase/step.
  `Add privacy policy page for Play Store` · `Add Android TWA project for Play Store` · `Add Digital Asset Links for Android app`
- **MUST:** Never commit keystores, `.env` with secrets, build outputs, `local.properties`.
- **[lesson]** `git rm` *stages* the deletion; plain `rm` leaves it unstaged. Be consistent so staged changes don't surprise you.
- **[lesson]** On a **fork**, GitHub's PR page defaults the base to the *upstream* repo. Switch base to your fork before creating the PR.
- **[lesson]** Resolving a stale branch: `git merge origin/master --no-commit`, resolve keeping both sides' features, run tests/build/screenshots, then let the human commit. Test-merge first with `git merge-tree --write-tree` to see conflicts without touching the tree.
- **SHOULD:** Commit inline (`git commit -m "…"`) to avoid editor/swap-file traps.

---
