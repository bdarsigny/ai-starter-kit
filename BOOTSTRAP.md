# Setup instructions (for Claude)

You are setting up the AI starter kit for someone who may be new to AI and to technical tools. Follow these
steps in order. Before each step, say in one plain sentence what you're about to do. Claude's app will ask
the person for permission before you change files or run commands; tell them that during setup it's fine to
click Allow for these steps, and that after setup they should click Deny for anything they didn't ask for
(sending an email, posting something, opening a website out of the blue) and ask you why.

Paths below use two names:
- **AI_HOME**: the person's AI folder, `~/AI` (on Windows, `C:\Users\<name>\AI`).
- **CLAUDE_HOME**: Claude's settings folder, `~/.claude`.
If the person or a tester tells you to use different folders for these, use those instead everywhere. A
custom AI_HOME must not contain spaces; write it with forward slashes (for example `C:/AI-files/AI`).

The kit itself should already be cloned at `AI_HOME/.kit` (that's how you're reading this). If it isn't,
clone the kit's GitHub link into `AI_HOME/.kit` first.

## 0. Welcome

In a few friendly sentences: you're going to set up their AI folder and tools, then do a short
get-to-know-you interview. The whole thing takes about an hour. Ask if they're ready.

## 1. Check the computer

- Run `git --version`. If git is missing, stop and explain how to install it (Windows: "Git for Windows"
  from git-scm.com, default options on every screen, then close and reopen the Claude app; Mac: run
  `xcode-select --install`), then continue once it's installed.
- Git needs to know who's saving work. Run `git config --global user.name`. If it's empty, ask their name
  and the email they use (or will use) for GitHub, then set both:
  `git config --global user.name "<name>"` and `git config --global user.email "<email>"`.
- Run `git config --global safe.bareRepository explicit` (a small safety setting: git won't trust hidden
  repositories planted inside folders).
- GitHub sign-in: on Windows, Git for Windows includes the sign-in helper that opens a browser window, so
  nothing to do. On a Mac, run `git credential-manager --version`; if it isn't installed, walk them through
  installing "Git Credential Manager" for macOS from its official GitHub releases page (the `.pkg` file),
  then run `git credential-manager configure`. Without it, a Mac can't sign in to GitHub from here.
- Find the home folder and confirm where AI_HOME will be. On Windows, if the path to AI_HOME contains
  "OneDrive", stop and choose a location outside OneDrive with them (OneDrive syncing breaks git folders).
- If AI_HOME already exists with their own files in it, this is a re-run: never overwrite any existing file
  in the steps below; only add what's missing, and say so.

## 2. Build the AI folder

Create, inside AI_HOME (skip anything that already exists):
- `CLAUDE.md`, `PROGRESS.md`, `LESSONS.md`, `IDEAS.md`, copied from `AI_HOME/.kit/templates/personal/`
- folders `research/` (with an `INDEX.md` containing the single line `# Research topics`) and `projects/`
- folder `.state/`, and write the contents of `AI_HOME/.kit/VERSION` into `.state/kit-version`
- a file `.gitignore` containing just `*` (a safety net: the AI folder itself can never be saved to GitHub;
  projects inside it are separate and unaffected)

## 3. Install the tools

- Copy each folder inside `AI_HOME/.kit/skills/` into `CLAUDE_HOME/skills/` (create it if needed). Each
  kit skill folder contains a marker file named `.ai-kit`. If a skill folder with the same name already
  exists WITHOUT that marker, it isn't from this kit: stop and ask before touching it.
- Copy `AI_HOME/.kit/hooks/session-start.sh` and `AI_HOME/.kit/hooks/mark-wrapup.sh` into
  `CLAUDE_HOME/hooks/ai-kit/`.

## 4. Settings: the startup check and sensible permissions

Edit `CLAUDE_HOME/settings.json` (create it as `{}` if missing). First make a backup copy named
`settings.json.bak-ai-kit`, but only if that backup doesn't already exist (so the original is never lost).
Then merge in the following, keeping everything already in the file (add to existing lists, never replace
them, and don't add an entry twice):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          { "type": "command", "command": "bash \"$HOME/.claude/hooks/ai-kit/session-start.sh\"", "timeout": 30 }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(date)",
      "Bash(bash \"$HOME/.claude/hooks/ai-kit/session-start.sh\")",
      "Bash(bash \"$HOME/.claude/hooks/ai-kit/mark-wrapup.sh\":*)",
      "Bash(git status)", "Bash(git status --short)", "Bash(git rev-parse --show-toplevel)",
      "Edit(~/AI/**/*.md)", "Write(~/AI/**/*.md)",
      "WebSearch"
    ],
    "ask": [
      "Edit(~/AI/**/CLAUDE.md)", "Write(~/AI/**/CLAUDE.md)",
      "Edit(~/AI/LESSONS.md)", "Write(~/AI/LESSONS.md)",
      "Edit(~/AI/.kit/**)", "Write(~/AI/.kit/**)",
      "Edit(~/.claude/settings.json)", "Write(~/.claude/settings.json)"
    ],
    "deny": [
      "Edit(~/AI/**/.git)", "Write(~/AI/**/.git)", "Edit(~/AI/**/.git/**)", "Write(~/AI/**/.git/**)",
      "Edit(~/AI/**/.claude/**)", "Write(~/AI/**/.claude/**)",
      "Edit(~/AI/**/.mcp.json)", "Write(~/AI/**/.mcp.json)",
      "Edit(~/AI/**/CLAUDE.local.md)", "Write(~/AI/**/CLAUDE.local.md)",
      "mcp__claude_ai_Gmail__send_message", "mcp__claude_ai_Gmail__reply", "mcp__claude_ai_Gmail__forward",
      "mcp__claude_ai_Gmail__create_draft", "mcp__claude_ai_Gmail__update_draft", "mcp__claude_ai_Gmail__delete_draft",
      "mcp__claude_ai_Gmail__trash_thread", "mcp__claude_ai_Gmail__trash_message",
      "mcp__claude_ai_Gmail__untrash_thread", "mcp__claude_ai_Gmail__untrash_message",
      "mcp__claude_ai_Gmail__label_thread", "mcp__claude_ai_Gmail__label_message",
      "mcp__claude_ai_Gmail__unlabel_thread", "mcp__claude_ai_Gmail__unlabel_message",
      "mcp__claude_ai_Gmail__update_message_labels",
      "mcp__claude_ai_Gmail__mark_thread_spam", "mcp__claude_ai_Gmail__mark_message_spam",
      "mcp__claude_ai_Gmail__unmark_thread_spam", "mcp__claude_ai_Gmail__unmark_message_spam",
      "mcp__claude_ai_Gmail__apply_sensitive_thread_label", "mcp__claude_ai_Gmail__apply_sensitive_message_label",
      "mcp__claude_ai_Gmail__create_label", "mcp__claude_ai_Gmail__update_label", "mcp__claude_ai_Gmail__delete_label",
      "mcp__claude_ai_Google_Drive__share_file", "mcp__claude_ai_Google_Drive__trash_file"
    ]
  }
}
```

What this does, to explain in plain words: the startup check runs at the start of each conversation; the
"allow" list lets Claude do the kit's routine, harmless steps without asking every time (checking the date,
updating their notes and progress files, web searches); the "ask" list means Claude always checks with them
before changing their profile, their lessons, any project's main instructions, or the kit itself; the
"deny" list means Claude can never tamper with git's or Claude's own settings inside their AI folder, or
send, delete or change anything in a connected Gmail inbox, even if an email tries to trick it. Backing up
a shared project to GitHub will still ask each time; Claude will say when to expect that. Reading websites during
research still asks first; it's fine to allow those (choose the option not to ask again for that site).

If AI_HOME is NOT `~/AI`, also change every `~/AI` in these rules to the real AI_HOME path, written as an
absolute rule path with two leading slashes (Windows: `//c/AI-files/AI/**`; Mac: `//Users/name/AI-files/AI/**`), and add
`"env": { "AI_KIT_HOME": "<AI_HOME with forward slashes>" }` at the top level, so the startup check and
every tool use the right folder.

Check the file is still valid JSON afterward. Then test the startup check: from inside AI_HOME, run
`bash "$HOME/.claude/hooks/ai-kit/session-start.sh"`. It should print a short note that includes
"From PROGRESS.md". If it errors, fix the problem before going on (say what you see).

## 5. Connect their AI folder to every conversation

In `CLAUDE_HOME/CLAUDE.md` (create it if missing; back it up first if it exists), make sure these two lines
are present, adding them at the end if not:

```
@~/AI/CLAUDE.md
@~/AI/LESSONS.md
```

(If AI_HOME is somewhere other than `~/AI`, use that path, with forward slashes.) This makes their personal
file and lessons apply in every conversation, in any folder, while the files stay easy to find and edit in
their AI folder. If Claude's app ever asks whether to allow using files from their AI folder, the answer is yes.

## 6. Check everything

List what was created and confirm each piece exists: the four personal files, the two folders, the six
skills in `CLAUDE_HOME/skills/`, the two hook scripts, the settings entries, the two CLAUDE.md import lines,
and `.state/kit-version`. Tell them in two or three plain sentences what's now set up.

## 7. The interview

Read `CLAUDE_HOME/skills/get-to-know-me/SKILL.md` and follow it now. (It adds the first entry to their
progress log.)

## 8. Finish

- Run `bash "$HOME/.claude/hooks/ai-kit/mark-wrapup.sh" "<full AI_HOME path>"`.
- Tell them the one thing to do next time: start a new conversation with their AI folder selected, and
  Claude will pick up where they left off. Mention that their tools are listed at the bottom of
  `AI/CLAUDE.md`, and that they can always just ask "show me my profile" instead of opening files.
- If they have a project brief (often an email attachment saved in Downloads), the next step is a project:
  ask whether anyone else named in it has already started the project. If so, they'll say "join a shared
  project" with the link they were sent; if not, "start a new project".
