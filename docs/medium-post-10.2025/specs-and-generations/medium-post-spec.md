# Medium Post Specification: "5 Hours, One LLM, and the Multi-Clipboard I Always Wanted"

## Target Audience
Software engineers, developers interested in AI-assisted development, macOS users

## Tone & Style
- **Concise**: **700 words maximum**
- **Friendly and easy to read**: Conversational, approachable
- **Funny**: This was a fun project - make it enjoyable to read, include comical LLM moments
- **Inspiring**: Focus on how experience + modern tools = rapid capability expansion
- **Emphasis**: Free app, available to anyone

## Core Message
Knowing a bit about parts of OS and software, combined with years of experience in the field, allows us to venture into new areas way faster than ever before. It's an exciting time to be a software engineer.

## Development Timeline (from commit history)
**~5 hours of actual work**

No need to break down by days - just emphasize it was about 5 hours total of hands-on work.

## Article Structure

### 1. Hook (40-60 words)
Open with the relatable frustration: macOS lacking multi-clipboard. Quick setup of the dilemma:
- Option A: Pay €10-20 for existing app
- Option B: Build it myself in ~5 hours
- Spoiler: I'm a software engineer, so obviously Option B

Add humor: "Because what kind of developer would I be if I took the sensible route?"

**Key message**: It was fun, it took ~5 hours, and now it's **free for anyone to use**.

### 2. The Journey (150-180 words)
**Starting with specification:**
- Simple prompt: "Let's specify a macOS menu bar app that manages clipboard copies..."
- 30 minutes of iterative spec refinement with LLM
- Specification-driven development: spec first, code follows

**The build process with comical moments (pick max 3):**
1. **"Execute .md files" fail**: First prompt was "execute clopy.md and open xcode" - LLM confused, replied "it cannot execute md files." Oops. Rephrased to "read clopy.md and create app..."
2. **Forgot dinner**: Got so engaged debugging paste functionality - "Forgot to make dinner, got really engaged here. Need to run to compensate this."
3. **Paste mystery**: "I'm unable to paste them" after multiple iterations → discovered sandboxing issues. Solution: Turned off sandboxing. It worked!

**What made it smooth:**
- Pattern: Start each session with "Read and learn clopy.md and the code"
- LLM handled boilerplate, I focused on requirements
- Switched from GPT-5 to Claude Sonnet 4 for better results
- Cross-validated with both LLMs at the end

**Then came the icon story...**

### 3. The Icon Story & Key Learning (220-250 words)
**The icon generation workflow (this was magical):**

Me: "I'm looking at the appicon and, maybe we can do something different? Can you generate me a set similar to icon used in the menu bar and I would then choose which one to continue?"

What the LLM did autonomously was fascinating:
1. Generated a Python script to create icon variations
2. Ran the script (did it know I had Python installed? 🤔)
3. Created an HTML preview page with all variants
4. Opened it in my browser for me to review

"Let's go with version 4 but with some different background" → Same autonomous workflow, presented colored versions.

Iterating through designs this way was a "vibe-way very nice experience." Manual workflow (Sketch/Figma, export, update Xcode): hours. This: minutes.

(One limit: "Removing the generated files, due to possible multiple iterations, failed. So I did it myself." Even AI has boundaries.)

**What made this possible - and this is the key:**

Years of software experience meant I knew:
- What questions to ask (and how to rephrase when prompts failed)
- When specs were wrong vs. code was wrong
- How to structure the problem (spec-first approach)
- When to switch tools (GPT-5 → Claude for better results)
- How to manage LLM context effectively

The LLM handled platform-specific details, boilerplate, and tedious tasks. I focused on architecture and requirements.

**This is the learning**: Knowing a bit about OS internals and software development, combined with years of field experience, allows us to venture into new areas way faster than ever before. It's not about LLMs replacing engineers—it's about amplifying what experience enables us to do.

### 4. The Release (60-80 words)
From "I need this" to "I use this daily" in about 5 hours of work.

**The app is now free and available for anyone:**
- Code on GitHub: https://github.com/svennu/clopy
- Downloadable .app and .dmg ready to use
- Planning App Store release, but already available now

No €20 purchase needed. Just grab it, use it, fork it, improve it.

### 5. Closing (120-140 words)
**The bigger picture:**

It's an exciting time to be a software engineer.

The barrier to entry for side projects, experiments, and "why not?" moments has never been lower. Have an itch? Scratch it. Miss a feature? Build it. Takes hours, not weeks.

The combination of knowing your way around operating systems, having architectural thinking from years of experience, and modern AI tools lets us venture into new territories at unprecedented speed.

You don't need to be a Swift expert. You don't need weeks of free time. You just need some foundation, some experience to guide the process, and willingness to experiment.

So next time you're looking at a €20 app thinking "I could build that..." - maybe you actually should. You might surprise yourself with how fast you can go from idea to daily-use tool.

And hey, if you build something cool, make it free for others too. **That's the fun part.**

## Key Data Points to Include
- **Timeline**: **~5 hours total work** (no day breakdown needed)
  - 30 minutes: Specification
  - ~4.5 hours: Implementation, debugging, polish, icons
- **Cost to user**: **FREE** - emphasize this
- **Tools**: 
  - LLMs: GPT-5 (initial spec), Claude Sonnet 4 (primary implementation)
  - Platform: Xcode, Swift, macOS
  - Approach: Specification-driven development (spec-first, code follows)
- **GitHub**: https://github.com/svennu/clopy
- **Status**: Using daily, free for anyone, App Store release planned
- **Key learning**: Experience + modern tools = rapid capability expansion

## Comical/Funny Moments to Include (MAX 3)
Choose maximum 3 of these for the article:
1. **"It cannot execute md files"** - Wrong prompt interpretation, had to rephrase
2. **"Forgot to make dinner, got really engaged here"** - The developer's reality
3. **"did it know I have interpreter set up? 🤔"** - On LLM autonomously generating Python script
4. ~~"Removing the generated files failed. So I did it myself."~~ - AI limitations (include as minor note)
5. **Paste operation mystery** - Multiple iterations to discover sandboxing issues

**Recommendation**: Use #1, #2, and #3 for best comedic flow

## Writing Guidelines
- **STRICT 700 word maximum** - be ruthless with editing
- **Friendly and conversational** - like talking to a fellow developer
- **More funny than serious** - this was a fun project
- Keep paragraphs short (2-4 sentences max)
- Use em-dashes for asides
- **Max 3 comical moments** - don't overdo it
- **Emphasize FREE availability** multiple times
- **Emphasize the "experience matters" theme** - this is core message
- Less technical jargon, more accessible
- No day-by-day timeline - just total hours
- End with positive, inspiring note
- Cut fluff, keep impact

## What NOT to Include
- Don't break down timeline by days/dates
- Don't make it overly technical
- Don't oversell the app features
- Don't make LLMs sound magical - they're tools
- Don't ignore the funny moments - they make it relatable
- Don't forget to emphasize it's FREE
- Don't be preachy about experience - keep it light

## Success Metrics for Article
Readers should finish thinking:
1. "That sounds fun - I could do this too"
2. "My years of experience actually matter MORE in the AI age"
3. "I should grab Clopy - it's free!"
4. "It IS an exciting time to be a developer"
5. "Maybe I should build that thing I've been thinking about"

## Additional Notes
- Use first person throughout
- Keep energy high but authentic
- The journey is as important as the destination
- Emphasize: experience + tools = superpower
- Make it clear: this is about amplification, not replacement
