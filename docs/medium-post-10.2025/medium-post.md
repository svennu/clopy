# 5 Hours, One LLM, and the Multi-Clipboard I Always Wanted  
*by Sven Kirsimäe* 

macOS is great — until you realize it still can’t remember more than one copied thing at a time. Copy a link, lose your code. Copy code, lose the link.

My choices were simple:  
**Option A**: pay €20 for an existing app.  
**Option B**: spend about five hours building exactly what I wanted.  
I’m a software engineer, so obviously I picked Option B. Because what kind of developer would I be if I took the sensible route?

Five hours later, I had the multi-clipboard I’d always wanted — and now it’s free for anyone to use.

![clopy](https://raw.githubusercontent.com/svennu/clopy/refs/heads/medium-post-10.2025/docs/medium-post-10.2025/clopy.png "clopy")

---

## The Journey

It started with a specification.

Prompt to the LLM:  
> “Let’s specify a macOS menu bar app that manages clipboard copies…”  

Thirty minutes of back-and-forth later, I had a basic spec in *clopy.md*.

Specification-driven development: spec first, code follows. I’ve been doing this for a while now — start with the spec, then code, keep the spec, iterate — and it really feels like the right way to work with LLMs.

Then came the comedy.

**Moment #1** — “Execute clopy.md and open Xcode”  
The LLM politely informed me it can’t execute Markdown files. Oops. Rephrased to “read clopy.md and create the app” — and we were off.

**Moment #2** — Forgot dinner  
Got so absorbed debugging paste behavior that I skipped dinner. Classic developer move — hunger fades when the bug’s on the run.

**Moment #3** — The paste mystery  
After several “I can’t paste them” failures, I discovered the real culprit: sandboxing. Turned it off. Paste works. Dinner can wait. Will need to deal with the sandboxing once I want to release.

My working pattern soon settled: start each specification session with “Read and learn clopy.md and the code.”  
The model handled boilerplate and platform quirks; I focused on requirements. When GPT-5 stumbled on Swift specifics, I switched to Claude Sonnet 4 — better results immediately. At the end, I cross-validated both.

Then came the icon adventure.

---

## The Icon Story

At some point I looked at the placeholder icon and thought, we can do better.

So I asked:

> “Can you generate a few icons similar to the menu-bar symbol so I can pick?”

The LLM responded like a polite, over-achieving intern. It:

1. Generated a Python script to create icon variations  
2. Ran the script (did it know I had Python installed?)  
3. Created an HTML preview grid with all variants  
4. Opened it in my browser for review  

![python](https://raw.githubusercontent.com/svennu/clopy/refs/heads/medium-post-10.2025/docs/medium-post-10.2025/python.png "python")
![icon](https://raw.githubusercontent.com/svennu/clopy/refs/heads/medium-post-10.2025/docs/medium-post-10.2025/icon.png "icon")

I picked version 4, asked for a different background, and it repeated the process — new colors, same automation.

What normally takes an hour in Sketch or Figma took minutes.  
One small limit: removing generated files failed, so I did it myself. Even AI interns need supervision.

---

## The Release

From “I need this” to “I use this daily” in roughly five hours:

- ~30 minutes for the spec  
- ~4½ hours for implementation, debugging, polish, and icons  

The app is free and available now:

- GitHub: [svennu/clopy](https://github.com/svennu/clopy)  
- Downloadable `.dmg` ready to use (see the **Releases** on GitHub)  
- App Store release planned  

No €20 purchase required — just use it, fork it, improve it.

---

## The Real Takeaway

Years of experience matter more than ever. I know what to ask, how to rephrase when prompts fail, when the spec is wrong versus the code, when to switch tools — and when it’s time to dive in myself.

I structure the problem; the LLM handles the details. But I can still code when it counts, and that makes all the difference.

Experience + modern tools = rapid capability expansion.

It’s not about replacing engineers — it’s about amplifying what experience enables us to do.

---

## The Bigger Picture

It’s an exciting time to be a software engineer.

The barrier to building small, useful tools has never been lower.  
Have an itch? Scratch it.  
Miss a feature? Build it.  
Hours, not weeks.

With a bit of platform know-how, architectural instincts from years in the field, and today’s AI tools, you can wander into new territory faster than ever.

You don’t need to be a programming expert in all the languages. You just need a foundation, curiosity, and the willingness to experiment.

So next time you see a €20 app and think, “I could build that,” — maybe you should.

You might end up with a daily-use tool, a fun story, and something free to share with others.

Experience + tools = superpower. Go use it.

---

*Tags:* Software Engineering · Productivity Tools · Open Source · macOS · AI  

---

*Post:* https://medium.com/@svenkirsime/5-hours-one-llm-and-the-multi-clipboard-i-always-wanted-0b2504bcd462