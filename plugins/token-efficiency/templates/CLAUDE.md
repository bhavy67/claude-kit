# <Project>

<One sentence: what it is and who it is for.>

## Commands
```sh
<install>   <dev>   <test>   <lint>   <typecheck>   <build>
```

## Architecture rules (the ones that must not be violated)
- <e.g. all data access goes through `lib/data`; features never import the vendor SDK>
- <e.g. no raw hex or px in components; use tokens>

## Quality bar
- Every feature has loading, empty, error and success states.
- Accessibility baseline: keyboard, visible focus, labels, reduced motion, no color-only meaning.
- Tests added or updated with the change. Run <test> and <typecheck> before finishing.

## Decisions not to reopen
- <decision> — <one-line reason>. Don't revisit unless the user does.

## Gotchas
- <one line each: symptom → fix. Only things that bit more than once.>

## Pointers
Plan: `PLAN.md` · Domain terms: `GLOSSARY.md` · Decisions: `docs/adr/`

<!-- Keep under ~100 lines. Status, history and procedures belong in docs or skills. -->
