# 5 Hours, One LLM, and the Multi‑Clipboard I Always Wanted

## Hook
macOS still doesn’t ship a multi‑clipboard. I hit that wall daily: copy a link, lose the snippet; copy code, lose the link. My choices: pay €10–20 for a third‑party app or spend ~5 hours building exactly what I want. I’m a software engineer—obviously I picked option B. Bonus: it’s FREE for everyone.

## The Journey
I started with a specification. Prompt to GPT‑5: “Let’s specify a macOS menu bar app that manages clipboard copies…” Thirty minutes of back‑and‑forth turned into a tight spec. With the spec driving decisions, I opened Xcode, wrote Swift, and let the LLM handle boilerplate while I handled requirements.

Comical moment #1: I initially told the model, “execute clopy.md and open Xcode.” It politely replied that it cannot execute Markdown files. Oops. Rephrased to “read clopy.md and create the app…” and we were off.

Comical moment #2: I got so engaged debugging paste behavior that I forgot to make dinner. Classic developer move. A quick stretch, then back to polishing UX and tightening behavior.

What made it smooth: I started each session with “read and learn clopy.md and the code” to prime context; the LLM cranked out scaffolding while I stayed focused on the spec. I switched from GPT‑5 to Claude Sonnet 4 for implementation quality, then cross‑validated with both at the end. Platform: macOS, Swift, Xcode. Approach: spec‑first, code follows.

## The Icon Story & Key Learning
At some point I looked at the app icon and thought, we can do better. I asked: “Can you generate a set similar to the menu‑bar icon so I can choose?” What happened next felt magical in the best pragmatic way. The LLM:
- Generated a small Python script to create icon variations
- Ran the script
- Produced an HTML preview page with all variants
- Opened it in my browser for review

Comical moment #3: did it know I had Python installed? 🤔 Either way, I picked “version 4,” then asked for different backgrounds. Same loop—script, HTML, preview—now with a spread of colors. Iterating visuals this way was a vibe: what used to take an hour of Sketch/Figma, export, and Xcode asset updates took minutes.

One limit: removing generated files across iterations failed—so I cleaned up manually. Even AI has boundaries.

Here’s the key learning. Years of experience mattered more than ever: knowing what questions to ask (and how to rephrase when prompts fail), sensing when the spec was wrong versus the code, structuring the problem (“spec first”), switching tools at the right moment (GPT‑5 → Claude), and managing context so the LLM stays helpful. The model handled platform details and tedious tasks; I focused on architecture and requirements. Experience + modern tools = rapid capability expansion.

## The Release
From “I need this” to “I use this daily” in about five hours of actual work: ~30 minutes for the spec, ~4.5 hours for implementation, debugging, polish, and icons. The app is FREE and available now:
- GitHub: https://github.com/svennu/clopy
- Downloadable .app and .dmg ready to use
- App Store release planned, but you can use it today

No €20 purchase needed—grab it, use it, fork it, improve it.

## Closing
It’s an exciting time to be a software engineer. The barrier to entry for “why not?” projects has never been lower. Have an itch? Scratch it. Miss a feature? Build it. With a bit of OS knowledge, some architectural instincts, and modern AI tools, hours—not weeks—can take you from idea to daily‑use tool.

You don’t need to be a Swift expert or have weeks of free time. You need a foundation, experience to guide the process, and a willingness to experiment. Next time you eye a €20 app and think, “I could build that…”—maybe you actually should. You might surprise yourself with how quickly you can ship something useful.

And if you do, consider making it free for others too. That’s the fun part—and the point.
