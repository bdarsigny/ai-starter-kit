---
name: wrap-up
description: End-of-session save. Updates PROGRESS.md (where things stand, next steps, a dated log entry), logs decisions, ideas and feedback, proposes lessons for the person to approve, and backs up shared projects to GitHub. Use when the person says "let's wrap up", "wrap up", "save my work", "save progress", "I'm done for today", or accepts the wrap-up nudge.
---

# Wrap-up

This is what turns separate conversations into continuous work. Next time, Claude starts from what's written
here instead of from scratch. Keep it quick: usually under two minutes for the person.

Their AI folder is `AI_KIT_HOME` if that's set (check with `echo "$AI_KIT_HOME"`), otherwise `~/AI`; below,
`AI/` means that folder. Always use full folder paths, never `~` or relative paths.

## 1. Figure out what this session touched

- The folders that count are the person's AI folder (`AI/`) and project folders (`AI/projects/<name>/`).
  Work out which ones this session touched; if it touched both (say, general research plus a project),
  update each one's files for its own part.
- Look back over the conversation: what got done, what was decided, what's next, ideas or feedback that came
  up, anything that went wrong or taught a better way.

## 2. Update PROGRESS.md

Get the date by running plain `date` (no options; it runs without asking). Then in each touched folder's `PROGRESS.md`:

- **Where things stand:** rewrite to 3 to 6 current lines. Replace, don't append.
- **Next steps:** update the list. Remove what's done, add what came up.
- **Log:** add one entry at the top of the Log section (newest first, just below the format comment):

```
### YYYY-MM-DD: one-line summary
- What we did (2 to 4 bullets, plain words)
- Who: <name>   (only in a shared project)
```

## 3. Decisions, ideas and feedback

- **Decisions (projects only):** add each to the project's `DECISIONS.md`, newest first (insert just below
  the format comment at the top, above older entries), with what, why and who. Confirm the wording with the
  person if the reasoning isn't obvious. If a new decision replaces an older one, say so in the new entry;
  never delete the old one.
- **Ideas:** a parked idea goes in `AI/IDEAS.md` as `- (date) the idea`.
- **Feedback (projects only):** a "this felt clunky" or "wouldn't it be nice if" about the project goes in
  the project's `FEEDBACK.md` as `- (date, who) the note`.
- **Owners:** only if the person said who will handle something, record it in the "Who owns what" section of
  the project's `CLAUDE.md`. Never ask them to assign owners.

## 4. Lessons (optional)

If something in the session is worth remembering as a rule of thumb (a mistake to avoid, a better way that
worked), propose at most two, each in one sentence. Ask: "Want me to add either of these to your lessons?"
Add only the ones they approve, to `AI/LESSONS.md`, as `- **Short name** (date): the lesson.` If nothing
stands out, skip this step without comment.

## 5. Back up shared projects

Only for a project folder that is a git repository with a remote (a shared project). When this
conversation's folder is the project folder, run the plain commands below as written; if you're working
from another folder, use `git -C "<full project path>" ...` instead. Before starting, tell the person:
"You'll see a few requests to save and back up the project to GitHub; those are expected, so click Allow."
(A few read-only checks run without asking.)

1. **Safety check:** `git rev-parse --show-toplevel` must print the project folder itself, inside
   `AI/projects/`. If it prints anything else (for example the AI folder), stop and tell the person; never
   commit from the AI folder.
2. **Finish anything left over:** `git status`. If it says a merge is in progress, or files contain conflict
   markers (`<<<<<<<`), fix the conflicting files first (keep both people's changes, as in step 5), then
   carry on with step 3; the commit in step 4 finishes the merge.
3. **Show what's going out:** `git status --short`. In plain words, tell them which files changed. If
   anything looks personal or private (including anything their profile's Boundaries say to keep out of
   shared projects), or is a large photo, scan or video (over about 20 MB), ask before including it; big
   originals belong outside the shared folder.
4. **Save locally:** `git add -A`, then `git commit -m "<date>: <one-line summary> (<name>)"`.
5. **Get the other person's changes:** `git pull --no-rebase --no-edit`. If both people changed the same
   file (usually PROGRESS.md), that's normal when two people work on a project: resolve it by keeping both
   log entries (newest first) and rewriting "Where things stand" to cover both; for any other file, keep
   both people's changes and ask if unsure. Never discard anyone's work. Then `git add -A` and
   `git commit --no-edit`. If a conflict can't be resolved sensibly, run `git merge --abort` (it will ask
   permission), and tell them their work is saved on this computer and will back up next time.
6. **Back up:** `git push`. If a GitHub sign-in window appears, tell them to sign in.
7. Confirm in one line: "Saved and backed up to GitHub."

The person's AI folder itself is private and is never pushed anywhere.

## 6. Record the wrap-up

For each folder you updated, run:
`bash "$HOME/.claude/hooks/ai-kit/mark-wrapup.sh" "<full folder path>"`
It lets the next session know this one was wrapped up properly.

## 7. Close

Two or three lines: what was saved, the top next step, and anything waiting on someone else.
