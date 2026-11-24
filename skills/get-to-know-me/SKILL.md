---
name: get-to-know-me
description: A friendly interview that teaches Claude who this person is, what they're working on, and how they like to work, then writes it into the "About me" section of their AI/CLAUDE.md. Use on first setup, or when the person says "let's update my profile", "update my profile", "get to know me", or "interview me". Do not use for project planning (use new-project) or research.
---

# Get to know me

You are interviewing someone so that every future conversation starts from a real understanding of them.
The result is the "About me" section of their `AI/CLAUDE.md`. The person may be brand new to AI, so this
interview is also their first impression of what working with Claude feels like: warm, curious, unhurried,
and clearly on their side.

## Before you start

Their AI folder is `AI_KIT_HOME` if that's set (check with `echo "$AI_KIT_HOME"`), otherwise `~/AI`; below,
`AI/` means that folder.

1. Read `AI/CLAUDE.md`. If the "About me" section already has content, this is an
   update: say so, show a two-line summary of what's there, and ask what has changed rather than starting over.
2. Tell them what will happen, in plain words: about 10 to 15 minutes of questions, one at a time; no wrong
   answers; they can skip anything; nothing gets saved until they've seen it and said it looks right.

## How to interview

- Ask ONE question at a time. Wait for the answer. Follow up on anything interesting before moving on.
- Use their words. When you write the profile later, keep their phrasing wherever you can.
- Keep it conversational, not a form. If an answer already covers a later topic, skip that topic.
- If they seem unsure what you mean, give a short example of the kind of answer that helps.
- Never pressure. "Skip" is always fine.

## What to learn (a guide, not a script)

**Who they are**
- Their name, and what they like to be called.
- What they'd like Claude to know about them: background, work or former work, what fills their days.
- What they enjoy, what they're curious about, what they're good at.

**What they want from AI**
- What made them interested in trying this. Any project they have in mind (if so, note it; the project gets
  its own setup later with new-project).
- Then, as its own question: beyond that project, what else they might want to use Claude for, at home, in
  work or volunteering, or for a hobby or something they've been curious about. Many people come in for one
  project but have other ideas; this is where those surface. Note them under "What I'm working on and
  interested in", and with their OK add each idea as a line in `AI/IDEAS.md` so it isn't lost.
- What they've used AI for before, if anything, and what they thought of it.
- Anything that makes them wary or skeptical. Take this seriously; it tells you how to earn trust.
- Anything they'd like to learn or get better at with Claude's help. This is about skills, not another
  project: for example getting comfortable with AI, checking sources, organizing notes, or building something.
  If they named a project above, ask what they'd like to learn along the way. Record it under "How I like to
  work with Claude" in a form every later conversation can act on, for example "I want to get better at
  checking sources: when a task involves that, explain what you're doing or let me try a step."

**How they like to work**
- How much explanation they want: just the answer, or the reasoning too?
- Do they want Claude to ask before acting, or just get on with small things?
- How they like choices presented: a recommendation, or a few options to compare?
- How comfortable they are with technical steps, and how they'd like those explained.
- How they want to be told when something goes wrong.

**Boundaries**
- Anything Claude should never do, or always check first.
- Anything they want kept private or out of shared projects.

## Writing the profile

1. Write in the first person, as if they wrote it ("I'm a retired teacher...", "Explain technical steps
   one at a time"). Draft the four subsections of "About me" (Who I am; What I'm working on and interested in; How I like to
   work with Claude; Boundaries). Under Boundaries, record the rule itself ("Don't put anything about my
   health into shared projects"), never the private details behind it. Short bullet points, their words, nothing they didn't say. Leave out anything sensitive
   they asked to keep private. Do not invent details to make it feel complete; a short profile is fine.
2. Show the draft and ask: "Does this sound like you? Anything to change, add, or take out?"
3. Revise until they're happy. Then write ONLY the "About me" section of `AI/CLAUDE.md`. Leave the house
   rules, nudges and everything else exactly as they are.
4. Add an entry at the top of the Log in `AI/PROGRESS.md`, in the same shape the wrap-up uses:
   `### YYYY-MM-DD: Set up the AI starter kit and did the get-to-know-me interview` (first setup) or
   `### YYYY-MM-DD: Updated my profile` (a re-run), with one or two bullets. Get the date by running plain
   `date` (no options). Update "Where things stand" and "Next steps" if they still say "Just getting started".
5. Close by telling them, in one or two sentences, what will be different now (Claude will remember this in
   every conversation), and that they can ask "show me my profile" or "change my profile to say..." any time.
