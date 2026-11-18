---
name: new-project
description: Sets up a project folder the right way (goal, background, progress, decisions, feedback, research), either just for this person or shared with others through a private GitHub repository. Also joins a project someone else shared. Use when the person says "start a new project", "set up a project", "join a shared project", "I have a project brief", or names something they want to work on over several sessions.
---

# New project (or join a shared one)

A project is anything someone will come back to over several sessions. Giving it its own folder means
Claude always knows the goal, what's been decided, and what's next.

Their AI folder is `AI_KIT_HOME` if that's set (check with `echo "$AI_KIT_HOME"`), otherwise `~/AI`; below,
`AI/` means that folder. Use full paths for every file and git command.

**First ask:** starting a new project, or joining one someone shared with you? If they have a project brief
that names other people, ask whether one of those people has already started it; if so, they're joining.

## A. Start a new project

1. **Talk it through briefly** (one question at a time): what's the project, what would "done" or "going
   well" look like, who's involved, and is it just for them or shared with someone? If they have a project
   brief, ask where the file is (an email attachment is usually in Downloads), read it, and use it as the
   background; confirm it with them rather than re-asking what it already answers.
2. **Pick a short folder name** together (lowercase, dashes, no spaces), for example `garden-plan`.
3. **Create the folder** `AI/projects/<name>/` by copying the templates from `AI/.kit/templates/project/`:
   `CLAUDE.md`, `PROGRESS.md`, `DECISIONS.md`, `FEEDBACK.md`, plus a `research/` folder with a one-line
   `research/INDEX.md`. If there's a brief, copy it into the project as `BRIEF.md` unchanged.
4. **Fill in the placeholders** in those files from the conversation, in the person's words:
   - `{{PROJECT_NAME}}`, `{{GOAL}}`, `{{BACKGROUND}}` (a short summary; if there's a `BRIEF.md`, end with
     "More detail in BRIEF.md"), `{{PEOPLE}}`.
   - `{{SHARED_RULE}}`: for a shared project, "This project is shared through GitHub. Wrap-up saves and
     backs it up; each session starts by getting the latest changes. Keep big photos, scans and videos
     outside this folder (or ask first); share notes and small copies instead." For a solo project, delete
     that line.
   - Leave "Who owns what" empty. Never ask them to assign roles.
   - Do not add plans, designs or structure they didn't ask for. The project starts small and grows.
5. **First steps:** put 1 to 3 concrete first steps under "Next steps" in `PROGRESS.md`, agreed with them.
6. **If it's shared**, ask whether to connect GitHub now or later. It's completely fine to start solo and
   share later (part C works any time); in a first session, later is often easier.
7. Tell them: to work on the project, start a new conversation with the `AI/projects/<name>` folder
   selected, and say "let's wrap up" at the end of each session.

## B. Join a shared project

1. Ask for the GitHub link they were sent (it looks like `https://github.com/<someone>/<project>`). They need
   to have accepted the GitHub invitation email first (invitations expire after a week; if it expired, the
   other person can send a new one).
2. Run `git -C "<full AI path>/projects" clone <link>`. If a GitHub sign-in window appears, tell them that's
   expected and to sign in.
3. Read the project's `CLAUDE.md` and `PROGRESS.md` and give them a short, friendly summary of where things
   stand. Suggest starting a new conversation with the project folder selected to work on it.

## C. Share a project through GitHub

Explain first, in plain words: GitHub keeps a private, backed-up copy of the project folder that the people
they invite can also use. Nobody else can see it.

1. **They create the empty repository** (Claude can't do this part for them). Walk them through it:
   go to github.com and sign in; click the **+** at the top right, then **New repository**; name it the same
   as the folder; choose **Private**; leave every other option unchecked; click **Create repository**. Ask
   them to copy the link shown on the next page and paste it here.
2. **You connect the folder.** Make sure `git config --global user.name` is set (if not, set name and email
   as in the setup). With `P` as the full project path, first check that `P` is a folder inside
   `AI/projects/` and is not the AI folder itself; stop if it isn't. Then:
   `git -C "P" init`, then confirm `git -C "P" rev-parse --show-toplevel` prints `P` itself, then
   `git -C "P" status --short` and tell them what will be shared (ask about anything large, or private per
   their profile's Boundaries), then `git -C "P" add -A`, `git -C "P" commit -m "Start project"`,
   `git -C "P" branch -M main`, `git -C "P" remote add origin <link>`, `git -C "P" push -u origin main`.
   Before running these, tell the person they'll see several requests to set up and back up the project on
   GitHub, and that clicking Allow for those is expected.
   If a GitHub sign-in window appears, tell them to sign in.
3. **They invite others:** on the repository page, **Settings**, then **Collaborators**, then
   **Add people**, and type the other person's GitHub username (GitHub may ask for their password again
   here; that's normal). The other person gets an email to accept within a week.
4. Confirm: "Your project is backed up on GitHub and shared with <name>."

Never put personal files (anything from `AI/` outside this project folder) into a shared project.
