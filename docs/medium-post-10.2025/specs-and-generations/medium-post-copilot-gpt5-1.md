# 5 Hours, One LLM, and the Multi-Clipboard I Always Wanted

I love macOS, but every time I copy something I wish the clipboard had memory. Option A: pay €10–20 for a multi-clipboard app. Option B: build the one I want—in about five hours—and make it free. I’m a software engineer, so obviously I chose B. Sensible route? Never met her.

## The Journey

In classic spec-first fashion, I started with a simple prompt: “Let’s specify a macOS menu bar app that manages clipboard copies…” Thirty minutes of back-and-forth with an LLM produced a crisp spec; once the spec felt right, code followed. My first hilarious misstep: I told the model to “execute clopy.md and open Xcode,” and it politely reminded me it cannot execute .md files. Fair—so I rephrased to “read clopy.md and create the app,” and we were off.

From there, the LLM handled boilerplate and platform quirks while I focused on requirements and UX. A reliable pattern emerged: each session started with “Read and learn clopy.md and the code” to re-ground context, and progress stayed snappy. I began on GPT-5, then switched to Claude Sonnet 4 for better results, and cross-validated with both at the end. Somewhere in the middle I got so engrossed in a paste-flow tweak that I forgot to make dinner—developer cliché achieved. Total hands-on time: about five hours, split roughly into 30 minutes of specification and ~4.5 hours of build, debugging, polish, and icons.

## The Icon Story & Key Learning

The most magical-feeling part was the icon. I glanced at the placeholder and asked, “Could we try something closer to the menu bar glyph? Generate a few options and I’ll pick.” The LLM spun up a tiny pipeline: it generated a Python script to produce icon variants, ran it—did it know I had Python installed?—created an HTML preview grid, and opened it in my browser.

I clicked through a gallery of options like I was shopping for logos. “Let’s go with version 4, but with a different background,” I said, and the loop repeated: script regenerated assets, preview refreshed, choices appeared. The manual flow—Sketch or Figma, export sizes, update Xcode asset catalog—would have taken hours. This took minutes, end-to-end, and felt like a “vibe-way very nice experience.”

The autonomy wasn’t magic; it was well-scoped instructions plus a tool that’s very good at orchestrating repetitive steps. My experience mattered in subtle but important ways: knowing what to ask for, when to rephrase, when the spec was wrong versus the code, when to switch tools (GPT-5 → Claude), and how to keep context tight. The LLM carried the boilerplate and platform details so I could stay in architecture and requirements mode. One limit: removing generated files across iterations didn’t quite work—so I tidied up manually. Even AI has boundaries.

## The Release

From “I need this” to “I use this daily” took about five hours of actual work. The app—Clopy—is free for anyone to try and keep. Code is on GitHub: https://github.com/svennu/clopy, and I’ve published downloadable .app and .dmg builds so you can run it immediately. An App Store release is planned, but you don’t have to wait. No €20 purchase required—just grab it, use it, fork it, improve it.

## Closing

It’s an exciting time to be a software engineer. The barrier to building small, useful tools has dropped dramatically—have an itch, scratch it. With a little OS know-how, architectural instincts from years in the field, and modern AI tooling, you can wander into new territory at surprising speed.

You don’t need to be a Swift expert or clear your calendar for weeks. You need a decent foundation, the ability to write a tight spec, a willingness to iterate, and the judgment to steer the AI. Hours, not weeks—that’s the shift.

So the next time you see a €20 app and think, “I could build that,” maybe you should. You might end up with a daily-use tool, a fun story, and something free you can share with others. Experience plus tools is a superpower—go use it.
