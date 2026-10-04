# The Tidy Suite

Four friendly apps that run in your web browser. No install, no account. Download one file, double-click it, and you're working. Everything saves on your own computer.

| App | What it does | Open it |
|---|---|---|
| **Tidy** | Spreadsheets: budgets, lists, anything with rows and columns | [`tidy/tidy.html`](tidy/tidy.html) |
| **Neat** | Writing: letters, notes, reports, with a helper that tells you how easy it reads | [`neat/neat.html`](neat/neat.html) |
| **Spruce** | Slides: build a talk, present it, save it as PowerPoint | [`spruce/spruce.html`](spruce/spruce.html) |
| **Steady** | Bills: a plan for every bill, a debt-free date, and progress you can see | [`steady/steady.html`](steady/steady.html) |

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

A bill tracker that gives you hope and a plan.

- **Start my plan** asks a few easy questions: your income, how often you're paid, which bills you have, and what a win looks like to you.
- **Bring your bills in** by importing a CSV or Excel file. When Steady runs inside Claude with Gmail connected, it can also read your bill emails (statements, due reminders, autopay receipts) and fill most of the list in for you, with months of history. You check everything before it's saved.
- **Today** shows a progress ring for the month and a colorful tile for every bill. Tap **Paid** and watch the ring fill.
- **Everyday spending** covers the money that isn't a bill: groceries and fuel by the week, plus eating out, household, pets, kids and kids' allowance, tobacco and vape, drinks, car upkeep, boat and recreation, club dues, gifts and more. Set each one per week, month or year, log what you spend, and see how much is left this week.
- **Upkeep** reminds you about the dentist, doctor and eye exams, each vehicle's oil, tire rotation, tires, brakes, battery and coolant, and your home: roof, windows, siding, deck, driveway, furnace, air conditioner, water heater, plus smaller jobs like a yearly foundation and basement check, furnace filter, tune-ups, deck sealing, driveway sealcoat and septic. For the big home items it just asks about what year they went in and how they're holding up (like new, good shape, about halfway, showing its age, near the end), then tells you roughly how many years are left and what to save each month so the replacement is paid for when it comes. When something comes due it asks if you've done it. Say "not yet", pick a reason, and it checks back in a month with how long it has been. Enter the odometer now and then, or how much life is left in the oil, tires or brakes, and Steady predicts when service is really due from how much you drive. It also estimates what upkeep costs per year and can turn that into a monthly set-aside.
- **Plan** gives your debt-free date, how much interest you save compared with paying minimums only, which debt to pay first (highest interest or smallest balance), and a paycheck-by-paycheck split.
- **Trends** charts your debt going down and points out what changed and why, like a utility bill rising with the seasons or a card that costs you the most in interest.
- **Talk** lets you tell Steady things in plain words, like "I paid the electric, it was 142". It can read its replies out loud.

When you open `steady.html` from your computer, the email scan and smart chat are switched off, since they need Claude. Everything else works and saves in that browser.

Steady does the math with the numbers you give it. It's not financial advice.

---
Made by hardwaremack.
