# The Tidy Suite

Four friendly apps that run in your web browser. No install, no account. Download one file, double-click it, and you're working. Everything saves on your own computer.

| App | What it does | Open it |
|---|---|---|
| **Tidy** | Spreadsheets: budgets, lists, anything with rows and columns | [`tidy/tidy.html`](tidy/tidy.html) |
| **Neat** | Writing: letters, notes, reports, with a helper that tells you how easy it reads | [`neat/neat.html`](neat/neat.html) |
| **Spruce** | Slides: build a talk, present it, save it as PowerPoint | [`spruce/spruce.html`](spruce/spruce.html) |
| **Steady** | Bills: a plan for every bill, a debt-free date, and progress you can see | [`steady/steady.html`](steady/steady.html) |

Open `index.html` for a home page that links all four apps.

They work together. Copy cells from Tidy and paste them into Neat or Spruce as a table. Open a Neat document in Spruce and each heading becomes a slide. Export your bills from Steady as a CSV and open them in Tidy.

## Tidy

![Tidy](tidy/screenshot.png)

A spreadsheet that stays out of your way. Formulas, charts and printing. The manual is in [`tidy/tidy-manual.pdf`](tidy/tidy-manual.pdf).

## Neat

![Neat](neat/screenshot.png)

A writing pad. Markdown-style shortcuts, checklists, highlighters, word goals, find and replace, and printing. The Sidekick panel shows how easy your writing is to read. Saves as Word, web page, Markdown or plain text.

## Spruce

![Spruce](spruce/screenshot.png)

Slides that come together easily. Layouts, themes, pictures, shapes, tables and speaker notes. Presents full screen with a timer. Prints slides, notes pages or handouts, and saves as PowerPoint or a slideshow web page.

## Steady

![Steady](steady/screenshot.png)

A bill tracker that gives you hope and a plan. Use as much or as little as you like: the first question asks what you'd like help with, and just bills is perfectly fine.

- **Start my plan** asks a few easy questions: what you'd like help with, your income, which bills you have, and what a win looks like to you.
- **Bring your bills in** from email or a spreadsheet. Paste a bill email or open saved emails (.eml or a mailbox export) from any provider, and Steady fills in the bill, amount, due date, and for cards the balance and interest rate. Inside Claude it can also scan Gmail directly. You check everything before it's saved.
- **Monthly or not.** Bills can be monthly, every 3 or 6 months, or yearly (like flood insurance), and Steady shows what to set aside each month.
- **Today** shows a progress ring for the month and a colorful tile for every bill. Tap **Paid** and watch the ring fill.
- **Mortgage breakdown** shows where the payment goes (principal and interest, taxes, insurance, PMI), how much equity you have, and when you can ask your lender to drop PMI.
- **Everyday spending** (optional) covers the money that isn't a bill: groceries and fuel by the week, plus eating out, household, pets, kids and kids' allowance, tobacco and vape, drinks, car upkeep, boat and recreation, club dues, gifts and more.
- **Upkeep** (optional) reminds you about checkups, car care, home upkeep and papers & renewals. When something comes due it asks if you've done it; say "not yet", pick a reason, and it checks back later. Car service dates follow how much you actually drive. Big home items (roof, windows, siding, deck, driveway, furnace, AC, water heater) just need the year they went in and how they're holding up, and Steady tells you roughly how many years are left and what to save each month. Papers & renewals (driver's license, plate tags, passport, CPL, boat registration, fishing and hunting license) only keep the expiration date, never ID numbers.
- **Paper files**: print matching folder tabs for a filing cabinet, one for each bill plus home, car, medical and everyday folders.
- **Plan** gives your debt-free date, how much interest you save compared with paying minimums only, which debt to pay first, and a paycheck-by-paycheck split.
- **Trends** charts your debt going down and weekly spending, and points out what changed and why.
- **Talk** lets you tell Steady things in plain words, like "I paid the electric, it was 142" or "spent 86 on groceries". It can read its replies out loud.

When you open `steady.html` from your computer, everything works and saves in that browser, including reading pasted or saved emails. Only the Gmail scan and the smarter chat need Claude.

Steady does the math with the numbers you give it. It's not financial advice.

---
Made by hardwaremack.
