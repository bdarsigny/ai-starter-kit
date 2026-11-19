---
name: update-kit
description: Gets the latest version of the AI starter kit (its tools and startup check) without touching anything the person wrote. Use when the person says "update my kit", "get the latest kit", or "are my tools up to date".
---

# Update my kit

Their AI folder is `AI_KIT_HOME` if that's set, otherwise `~/AI`; below, `AI/` means that folder.
The kit lives in `AI/.kit/`, a copy of the kit's GitHub repository. Updating means getting the newest copy
and reinstalling the tools from it. The person's own files (their CLAUDE.md, progress, lessons, ideas,
research and projects) are never changed by an update.

1. Run `git -C "<AI folder>/.kit" pull --ff-only`. If a GitHub sign-in window appears, tell them to sign in.
   If the pull fails because something in `.kit` was edited by hand, explain that `.kit` is meant to stay
   as-is, and ask before resetting it.
2. Compare `AI/.kit/VERSION` with `AI/.state/kit-version` to know what's new, but reinstall either way
   (it's quick and catches anything that drifted).
3. Reinstall, exactly as the setup did:
   - Copy each folder in `AI/.kit/skills/` into `~/.claude/skills/`. Replace an existing folder only if it
     contains the `.ai-kit` marker file; if a same-named folder lacks the marker, leave it and tell them.
   - Copy `AI/.kit/hooks/*.sh` into `~/.claude/hooks/ai-kit/`.
   - Merge the whole settings block from `AI/.kit/BOOTSTRAP.md` step 4 into `~/.claude/settings.json` (back
     it up first). If `AI_KIT_HOME` is set, first rewrite every `~/AI` in the block to its `//`-absolute form,
     exactly as BOOTSTRAP step 4 describes, so entries are compared and added in the form this computer uses: add any missing hook, allow, ask or deny entries, and remove any entry the CHANGELOG says
     was dropped. Keep everything else in the file. Exception: never re-add a deny entry the person deliberately
     removed. Skip only the entries named exactly, word for word, on the "Abilities I've turned on"
     line in the "My settings" section of `AI/CLAUDE.md`; re-add any other missing deny entry. Then check the two import lines from step 5 are still in
     `~/.claude/CLAUDE.md`.
4. If the versions differed, read `AI/.kit/CHANGELOG.md` and tell them, in plain words, what's new since their old version.
5. If the changelog says a template changed (for example new house rules or nudges in the personal
   `CLAUDE.md`), do NOT overwrite their file. Show them the suggested change and add it only if they agree.
6. Write the new version number to `AI/.state/kit-version`.
7. Tell them to start a fresh conversation so the updated tools load.
