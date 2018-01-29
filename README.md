# iOS Dev Weekly issue 👉 Instapaper automation

This is a small Ruby (don't be too picky, I'm a Swift dev) script to automate [iOS Dev Weekly](https://iosdevweekly.com/) articles to be pushed to Instapaper.

## Why

Automation FTW, London tube, laziness, etc

## How it works

It fetches RSS, filters article titles and links from there and pushes them to Instapaper.

## How to use

- Copy `secrets.sample.rb` to `secrets.rb`, put your Instapaper credentials there and run `main.rb`. 
- It saves the latest issue `guid` to `.lastKnownGuid` file so it won't pollute your Instapaper with duplicates, don't worry.
- And it's intended to be used in cron jobs :muscle:

## Pocket support?

You're welcome to make a Pull Request :+1: or I'll add it eventually

## License

MIT
