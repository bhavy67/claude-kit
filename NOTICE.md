# Third-party notices

Parts of this repository are adapted from open-source work. Original licenses apply to those parts.

## mattpocock/skills (MIT, Matt Pocock)
Source of: `plugins/engineering-workflow/skills/{grilling, grill-with-docs, tdd, code-review, codebase-design, domain-modeling, improve-codebase-architecture, implement}`.
Vendored from a copy in a project of this repo's author. Unmodified except `implement`, whose final instruction was changed to: do not commit or push on your own, finish with a short summary and a suggested one-line commit message, and commit only when the project's git rules or the user say so.
Upstream: https://github.com/mattpocock/skills (MIT License, copyright Matt Pocock).

## shadcn/ui skill (MIT)
Source of: `plugins/frontend-ui/skills/shadcn/`. Copied from a project of this repo's author, with assets, evals and agent files removed.
Upstream: https://github.com/shadcn-ui/ui (MIT License). TODO before publishing: confirm the copyright holder line against the upstream LICENSE file and add the full text here.

## Not vendored (install from upstream)
- Anthropic `frontend-design` and other skills: `/plugin marketplace add anthropics/skills` (Apache-2.0).
- Anime.js skills: `npx skills add bowtiedswan/animejs-skills` (license not verified, so not copied).

Everything else in this repository is original work under the MIT License in `LICENSE`.
