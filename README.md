![](assets/static/images/logo.jpg)

# PixelSmash Areeeenaaa!!!

Spectators! Get your bets ready for the next season of PixelSmash Arena! This time we have new Gladiators coming from all corners of the pixel-verse, ready to give it their all. As the fights progress some will triumph, some will be pixelated, and new fighters will be born from freak cosmic fusion accidents!

The latest version is running [here](https://ruddy-rosy-mallard.gigalixirapp.com/).

# Start the Season!

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Design Goals

The goal of our project was to create a multiplayer online game where you bet on simulated matches between procedurally generated gladiators, later spending your earnings to outfit the gladiators with equipment, and to upgrade your account's capabilities.

When the server starts up, we generate 16 random gladiators. In order to do so, we generate a random 5x10 grid of pixels. We then mirror this this grid along the y-axis to make a randomly generated sprite for the gladiator. Each pixel color also corresponds to a specific stat (like strength, vitality, magic), and different combinations of pixels
lead to the gladiator possessing different skills, spells, and combat capabilities.

Gladiators also track stats (wins, losses, draws, and an ELO ranking), which are used to calculate betting odds and payouts for the simulated battles.

While the server is running, we also constantly run simulated battles between the gladiators. This is coordinated by a matchmaking server, that ensures there's always two series of battles being managed: the upcoming battles, and the currently running battles. Once all of the currently running battles finish, or a time limit is hit, the scheduled battles begin.

Betting is facilitated by a bookie server, that uses Phoenix PubSub to subscribe to battles being scheduled, started, and finished. It maintains an open book, and a closed book, for the scheduled and running battles respectively, and accepts bets from user accounts against any of the scheduled battles. The odds are calculated using the ELO ratings of the matchup, and the payouts are adjusted accordingly.

We also randomly generate items, that are available for purchase in the shop. Items also take the form of an image, and represent an overlay that can be applied over a gladiator. For example, a helmet will combine with the pixels on the gladiator's head, in order to transform the gladiator in some way. We were able to procedurally generate and display the items in a shop, however we ran out of time to implement actually purchasing them and equipping them to a gladiator.

The battles work like a deckbuilding card game. Based on the gladiator's stats, they are given a deck consisting of actions, attacks, skills, and spells. They then take turns drawing cards from their deck and applying them to the battle in some way. When the deck runs out of cards, it is reshuffled. Once one gladiator's health reaches below zero, the battle is over.

