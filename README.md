# FlammeRubuge

A Ruby implementation for the [Flamme Rouge](https://boardgamegeek.com/boardgame/199478/flamme-rouge) board game.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flamme_rubuge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flamme_rubuge

## Usage

To create a Race, you need to pass it player details (names, cyclists) and a track.

The current_turn needs to have the played_cards Hash populated in the format `{ Cyclist: Card }'. Then run turn.movement and turn.end. Check if any cyclists have finished (Cyclist#finished? or Cyclist#finish_position). Then run Race#next_turn and go again.

For a more in-depth example of a turn, see the turn_spec.rb file.

## Tracks

Two simple tracks have been included. See the TrackBuilder class for how they have been built. Following those instructions and examples, it's fairly simple to add more tracks. Uphill, downhill, supply zone and cobbles are all supported, as are small differences if there are more than a certain number of players taking part.
