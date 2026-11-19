# Start here

This kit turns Claude into a working partner that remembers you and your projects. Out of the box, every
conversation with Claude starts from scratch. With the kit, Claude knows who you are and how you like to
work, picks up where you left off, researches with sources you can check, and keeps a running record of
decisions and lessons. That record builds up over time instead of disappearing into old chats.

## Before you start

You should already have these from the prep checklist (if not, see the end of this page):
- Claude Pro, and the Claude desktop app installed and signed in
- Git installed (Windows: Git for Windows)
- A GitHub account, if you'll share a project with someone

## Setup (about an hour, including a short interview)

1. In the Claude desktop app, switch to the **Code** tab and start a new session with your **home folder**
   selected (on Windows, the folder with your name inside `C:\Users`).
2. Paste the setup message you were sent. Claude explains each step as it goes, and asks permission before it
   creates files or runs anything: during setup, click **Allow**. If a GitHub sign-in window appears, sign in.
3. When setup finishes, Claude interviews you for about 15 minutes so it knows who you are, what you're working
   on, and how you like to work. Everything it learns goes into one file you can read and change.

## How it works

- **Your AI folder.** Setup creates a folder called `AI` in your home folder. `AI/CLAUDE.md` is your profile
  plus a handful of house rules (explain the plan first, cite sources, leave a gap rather than guess).
  Claude reads it at the start of every conversation.
- **Projects.** Each project gets its own folder under `AI/projects/`, with its goal, a progress log, a
  decisions log and a feedback file. A project you share with someone is backed up to GitHub, and each of you
  works on your own computer.
- **Continuity.** Start each session with your `AI` folder, or a project folder, selected. Claude opens with
  where you left off. Say **"let's wrap up"** at the end, and it saves progress, decisions and lessons.
- **Research.** Say **"research ..."** for careful work with sources rated for trustworthiness, saved as notes
  so you never look the same thing up twice.

Other phrases that work: **"start a new project"**, **"join a shared project"**, **"check my newsletters"**,
**"show me my profile"**, **"update my kit"**. Your full list of tools is at the bottom of `AI/CLAUDE.md`.

## Good to know

- **When to click Deny:** after setup, if Claude asks to send an email, post something, share a file, or open a
  website you didn't ask about, click **Deny** and ask why. Backing up a shared project to GitHub and reading websites
  during research you asked for are fine to allow; Claude will say when to expect those.
- **Connected email:** out of the box, Claude can read a connected Gmail inbox but can't send, draft,
  delete, label or change anything in it. That's deliberate: emails come from strangers, and one could be
  written to trick Claude into acting on your behalf (prompt injection). The newsletter tool is meant for an inbox used only
  for subscriptions, and it asks first if the connected inbox looks personal.
- **Want Claude to do more with your email?** You can turn on any of those abilities whenever you're ready.
  Say "I'd like you to be able to draft emails" (or label, archive, send). Claude shows you the exact
  setting it will change and waits for your OK, then records your choice in your profile so a kit update
  never quietly turns it back off. Even then, Claude still asks you each time it uses that ability; answer plain Yes, not "don't ask again", to keep it that way. A sensible order: drafts first (Claude writes, you review and press
  send), then organizing (labels, archive), and sending last, if ever.
- **If Claude says you've reached your limit:** nothing is lost. It resets at the time shown. When you come
  back, say "let's wrap up" if you didn't get to before.
- **If Claude's app asks whether to allow using files from your AI folder,** say yes.

## If you haven't set things up yet

- **Git:** Windows: install "Git for Windows" from git-scm.com with the default options, then close and
  reopen the Claude app. Mac: nothing now, unless your kit link is private; then install "Git Credential
  Manager" for Mac first.
- **Claude:** sign up for Claude Pro at claude.ai, then download the desktop app from claude.ai/download.
- **GitHub (only for shared projects):** create a free account at github.com. GitHub may ask you to set up a
  second way to confirm it's you; that's normal. Accept any invitation email within a week.
