# AI starter kit

A small, opinionated setup for Claude (desktop app, Code tab) that gives a new user good habits from day one:

- **Context that persists:** a personal `CLAUDE.md` filled in by an interview, imported into every conversation.
- **Research with sources:** a research tool that prefers primary sources, rates them, and saves notes that
  build up over time.
- **Continuity:** a wrap-up tool and a startup check, so each session picks up where the last one ended.
- **Lessons and decisions:** approved lessons and per-project decision logs that Claude follows.
- **Projects, solo or shared:** a standard project folder, optionally shared through a private GitHub repo.
- **Newsletter mining:** pulls recommendations and events out of a dedicated newsletter inbox.

New users: read `START-HERE.md`. Claude: setup instructions are in `BOOTSTRAP.md`.

## Contents

- `START-HERE.md`: the person's setup guide
- `BOOTSTRAP.md`: what Claude does on first setup
- `templates/personal/`: the person's AI folder files
- `templates/project/`: a project folder's files
- `skills/`: get-to-know-me, research, wrap-up, check-newsletters, new-project, update-kit
- `hooks/`: the startup check and the wrap-up marker (bash; Git Bash on Windows)
- `tests/`: checks for the hook scripts (run on macOS and Windows in CI)

The kit is identical for everyone. Personalization comes from the interview and from each person's projects,
never from editing the kit.
