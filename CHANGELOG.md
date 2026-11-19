# Changelog

Newest first. The update-kit tool reads this to tell people what's new. Call out explicitly: any template
change (templates are never overwritten in a person's folder; update-kit offers the change instead) and any
permissions change (update-kit merges added entries and removes entries listed here as dropped).

## 0.2.0 (2026-11-18)

- Permissions change: new conversations start in auto mode ("defaultMode": "auto"), so building doesn't mean
  approving every action. Deny and ask rules still hold in every mode. Falls back to acceptEdits where auto
  isn't offered.
- Research is now kept like a small knowledge base: each topic folder has a running SUMMARY.md, one note per
  question in notes/, and one file per source in sources/ (reused across notes), plus a research INDEX.md
  listing topics.
- Template change (personal CLAUDE.md): a [Permissions] nudge and an "Abilities I've turned on" line
  under My settings. update-kit offers these; it doesn't overwrite your file.
- update-kit won't re-block an email ability you deliberately turned on (it skips only the exact settings
  entries recorded in your profile).
- Permissions change: Claude now always asks before editing ~/.claude/settings.json, and Google Drive's
  share and trash tools are blocked by default (added to "deny"), like Gmail's write tools.

## 0.1.0 (2026-11-17)

- First version: personal and project templates, six tools (get-to-know-me, research, wrap-up,
  check-newsletters, new-project, update-kit), the startup check and wrap-up marker.
