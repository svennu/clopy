# 5 Hours, One LLM, and the Multi-Clipboard I Always Wanted

macOS doesn't have a multi-clipboard manager. I had two options: pay €10-20 for an existing app, or build it myself in about 5 hours.

I'm a software engineer, so obviously I chose Option B. Because what kind of developer would I be if I took the sensible route?

Five hours later, I had exactly what I wanted—and now it's **free for anyone to use**.

## The Journey

It started with a simple prompt: "Let's specify a macOS menu bar app that manages clipboard copies..." Thirty minutes of back-and-forth with an LLM, and I had a solid spec. Specification-driven development: spec first, code follows.

Then came the fun part.

My first prompt to actually build it was "execute clopy.md and open xcode." The LLM politely informed me that "it cannot execute md files." Oops. I rephrased to "read clopy.md and create the app..." Much better.

The build process was surprisingly smooth. My pattern: start each session with "Read and learn clopy.md and the code." The LLM handled all the boilerplate Swift and macOS API details while I focused on requirements. When GPT-5 struggled with certain implementation details, I switched to Claude Sonnet 4. Better results immediately.

Then came the paste functionality debugging. After multiple iterations of "I'm unable to paste them," I discovered the culprit: sandboxing. Solution? Turned off sandboxing. It worked!

I got so engaged in this debugging session that I forgot to make dinner. Had to go for a run to compensate. The developer's reality.

## The Icon Story

This was where things got genuinely interesting.

Me: "I'm looking at the appicon and, maybe we can do something different? Can you generate me a set similar to icon used in the menu bar and I would then choose which one to continue?"

What happened next was fascinating. The LLM autonomously:
1. Generated a Python script to create icon variations
2. Ran the script (did it know I had Python installed? 🤔)
3. Created an HTML preview page with all variants
4. Opened it in my browser for review

"Let's go with version 4 but with some different background" → same autonomous workflow, new colored versions presented.

Iterating through designs this way was a vibe-way very nice experience. The manual workflow—Sketch or Figma, export, update Xcode assets—would have taken hours. This took minutes.

(One limitation: "Removing the generated files, due to possible multiple iterations, failed. So I did it myself." Even AI has boundaries.)

## What Made This Possible

Here's the key: years of software experience meant I knew what questions to ask and how to rephrase when prompts failed. I knew when the spec was wrong versus when the code was wrong. I understood how to structure the problem with a spec-first approach. I recognized when to switch tools for better results. I managed LLM context effectively.

The LLM handled platform-specific Swift details, macOS API boilerplate, and tedious icon generation. I focused on architecture and requirements.

**This is the learning**: knowing a bit about OS internals and software development, combined with years of field experience, allows us to venture into new areas way faster than ever before. It's not about LLMs replacing engineers—it's about amplifying what experience enables us to do.

## The Release

From "I need this" to "I use this daily" in about 5 hours of work.

**The app is now free and available for anyone:**
- Code on GitHub: https://github.com/svennu/clopy
- Downloadable .app and .dmg ready to use
- Planning App Store release, but already available now

No €20 purchase needed. Just grab it, use it, fork it, improve it.

## The Bigger Picture

It's an exciting time to be a software engineer.

The barrier to entry for side projects, experiments, and "why not?" moments has never been lower. Have an itch? Scratch it. Miss a feature? Build it. Takes hours, not weeks.

The combination of knowing your way around operating systems, having architectural thinking from years of experience, and modern AI tools lets us venture into new territories at unprecedented speed.

You don't need to be a Swift expert. You don't need weeks of free time. You just need some foundation, some experience to guide the process, and willingness to experiment.

So next time you're looking at a €20 app thinking "I could build that..."—maybe you actually should. You might surprise yourself with how fast you can go from idea to daily-use tool.

And hey, if you build something cool, make it free for others too. **That's the fun part.**
