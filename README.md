# The Tidy Suite

Seven friendly apps that run in your web browser. No install, no account. Download one file, double-click it, and you're working. Everything saves on your own computer.

| App | What it does | Open it |
|---|---|---|
| **Tidy** | Spreadsheets: budgets, lists, anything with rows and columns | [`tidy/tidy.html`](tidy/tidy.html) |
| **Neat** | Writing: letters, notes, reports, with a helper that tells you how easy it reads | [`neat/neat.html`](neat/neat.html) |
| **Spruce** | Slides: build a talk, present it, save it as PowerPoint | [`spruce/spruce.html`](spruce/spruce.html) |
| **Steady** | Bills: a plan for every bill, a debt-free date, and progress you can see | [`steady/steady.html`](steady/steady.html) |
| **Clearout** | Selling: price your stuff, write the listing, handle buyers, offer local services, track every sale | [`clearout/clearout.html`](clearout/clearout.html) |
| **Handy** | Side income: offer local services, price yourself, find customers, track jobs and debt paid down | [`handy/handy.html`](handy/handy.html) |
| **Sorted** | Repairs: step-by-step troubleshooting for engines, vehicles, HVAC and appliances, plus what to bill, flip price and cost to own | [`sorted/sorted.html`](sorted/sorted.html) |

Open `index.html` for a home page that links all seven apps.

They work together. Copy cells from Tidy and paste them into Neat or Spruce as a table. Open a Neat document in Spruce and each heading becomes a slide. Export your bills from Steady as a CSV and open them in Tidy. Need money for those bills? Clearout helps you sell what you don't use, and Handy helps you earn with your time and skills. Fixing something to sell or for a customer? Sorted walks you through the repair and tells you what to charge.

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

## Clearout

![Clearout](clearout/screenshot.png)

For people with too much stuff who want to turn it into money. It takes the stress out of selling.

- **Price it** gives you three numbers for any item: a price to list at, its fair value, and a walk-away price so you know your limit before anyone messages you. Add a few sold prices you've seen and it leans on those.
- **List it** writes a title and description that explain the price, and ranks Facebook Marketplace, Craigslist, Nextdoor, eBay and more for that item.
- **Handle buyers** checks any offer (take it, counter, or pass) and gives you a reply to copy. A quick checklist tells genuine buyers from resellers, time-wasters and scams. Real buyers can get a small discount; lowballers get a polite no.
- **Offer a service** turns what you have (a truck, tools, a mower, computer skills) into local service ideas with starting prices, works out your hourly rate from what you need each month, and writes your posts, quotes and thank-you messages.
- **Dashboard** checks in on each item: "Did it sell?" Say yes, enter the price, and a bell rings. Say not yet, pick what happened, and it suggests a fix like a lower price, a different site, or a fresh relist. Every sale goes into Your wins, and it shows which site makes you the most.

Prices are estimates. Real sold prices near you are always better.

## Handy

![Handy](handy/screenshot.png)

You need money. That's okay. Your neighbors need you. Handy helps you turn what you already know and own into side income, with a lot of encouragement along the way.

- **Start here** asks your goal for the month, the hours you can give, and the debt you want to pay down (your total from Steady works great). It shows how many months to pay it off and walks you through five first steps.
- **What I can do**: tap your tools and skills to see 27 local services with starting prices. Heart the ones you'd enjoy (if you enjoy it, it's not work) and pick the ones to offer.
- **My prices** works out the hourly rate you need, lets you set each price, and tells you if it meets your goal. Includes pricing tips and what to say when someone asks for cheaper.
- **Get the word out** covers Nextdoor, Facebook groups, Marketplace, flyers and word of mouth, writes your post in a friendly, professional or flyer style, and gives you an easy week plan.
- **What to say** has 13 ready messages: first reply, quotes, saying no, confirmations, running late, payment, reviews, referrals, regulars and raising prices.
- **Jobs & progress**: log each paid job and a bell rings. A ring fills toward your monthly goal, a bar shows debt paid down, and it tracks your hourly rate, reviews and repeat customers.

## Sorted

![Sorted](sorted/screenshot.png)

Fix it the smart way, one step at a time. For the jet ski that won't start, the mower that dies, the furnace that keeps shutting off, or the washer that won't drain. Sorted keeps you from replacing parts you don't need and from getting buried when you don't know where to start.

- **New project** asks three things: what you're working on (jet ski, car or truck, 4-wheeler, lawn mower, motorcycle, boat, snowblower, chainsaw, generator, furnace or AC, water heater, washer or dryer, fridge, dishwasher, or another appliance), your goal, and what it's doing.
- **Your goal** shapes the whole project: enjoy it yourself, fix it for someone for money, fix it to sell, or sell it as-is.
- **Do this next** shows one step at a time, cheapest and easiest checks first. Each step says why, how, what tools you need and what it costs. Mark it fine, found a problem, or skip. A found problem tells you what it points to and can add the part to your list.
- **Troubleshoot** shows the full checklist with your notes and what you've ruled out.
- **Parts** keeps a list of what you need and what you bought. Anything that hasn't failed a test is marked "not confirmed yet" so you test before you buy.
- **Money** has four calculators: **What to bill** (labor, parts markup, shop supplies, and a quote to copy for your customer), **Flip price** (list price, break-even floor and what you earn per hour), **Sell as-is?** (which nets more: selling now or fixing first), and **Cost to own** (yearly upkeep, cost per use, and repair-or-replace for appliances).
- **Notes** logs everything you checked and found, with dates.

Safety notes are built in: gas smell, AC capacitors, and refrigerant work that needs a licensed tech. Two example projects (a Sea-Doo flip and a furnace) show how it works.

---
Made by hardwaremack.
