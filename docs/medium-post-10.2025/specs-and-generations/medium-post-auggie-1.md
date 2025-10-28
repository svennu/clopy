# 5 Hours, One LLM, and the Multi-Clipboard I Always Wanted

macOS still doesn't have a multi-clipboard. You know the pain: copy a link, lose your code snippet. Copy some text, lose the link. My options were simple: pay €10-20 for an existing app, or spend about 5 hours building exactly what I wanted.

I'm a software engineer. Obviously I picked option B. Because what kind of developer would I be if I took the sensible route?

The best part? It took about 5 hours, it was fun, and now it's **free for anyone to use**.

## The Journey

I started with a specification. Simple prompt to the LLM: "Let's specify a macOS menu bar app that manages clipboard copies..." Thirty minutes of iterative refinement later, I had a solid spec. Specification-driven development: spec first, code follows.

Then came the build process, complete with some comical moments.

**Moment #1: "It cannot execute md files"**  
My first prompt was "execute clopy.md and open xcode." The LLM politely informed me that it cannot execute Markdown files. Right. Rephrased to "read clopy.md and create the app..." and we were off.

**Moment #2: Forgot dinner**  
I got so engaged debugging the paste functionality that I completely forgot to make dinner. The developer's reality: when the code is almost working, who needs food?

**Moment #3: The paste mystery**  
After multiple iterations of "I'm unable to paste them," I finally discovered the culprit: sandboxing issues. The solution? Turned off sandboxing. It worked!

What made the process smooth was a simple pattern: start each session with "Read and learn clopy.md and the code." The LLM handled all the boilerplate while I focused on requirements. I switched from GPT-5 to Claude Sonnet 4 for better implementation results, then cross-validated with both LLMs at the end.

Then came the icon story...

## The Icon Story & Key Learning

At some point, I looked at the app icon and thought we could do better. I asked: "I'm looking at the appicon and, maybe we can do something different? Can you generate me a set similar to icon used in the menu bar and I would then choose which one to continue?"

What happened next was fascinating. The LLM autonomously:
1. Generated a Python script to create icon variations
2. Ran the script (did it know I had Python installed? 🤔)
3. Created an HTML preview page with all the variants
4. Opened it in my browser for me to review

I picked version 4, then asked for "some different background." Same autonomous workflow—it presented me with colored versions.

Iterating through designs this way was a "vibe-way very nice experience." The manual workflow (Sketch or Figma, export, update Xcode assets) would have taken hours. This took minutes.

One small limit: "Removing the generated files, due to possible multiple iterations, failed. So I did it myself." Even AI has boundaries.

**Here's what made this possible—and this is the key:**

Years of software experience meant I knew:
- What questions to ask (and how to rephrase when prompts failed)
- When the spec was wrong versus when the code was wrong
- How to structure the problem (spec-first approach)
- When to switch tools (GPT-5 → Claude for better results)
- How to manage LLM context effectively

The LLM handled platform-specific details, boilerplate, and tedious tasks. I focused on architecture and requirements.

**This is the learning**: Knowing a bit about OS internals and software development, combined with years of field experience, allows us to venture into new areas way faster than ever before. It's not about LLMs replacing engineers—it's about amplifying what experience enables us to do.

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

So next time you're looking at a €20 app thinking "I could build that..." - maybe you actually should. You might surprise yourself with how fast you can go from idea to daily-use tool.

And hey, if you build something cool, make it free for others too. **That's the fun part.**

