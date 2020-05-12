require 'spec_helper'

describe FlammeRubuge::Race do
  let(:cyclist_types) { FlammeRubuge::Cyclist::TYPES }
  let(:sprinter) { cyclist_types.detect { |t| t[:type] == :sprinteur } }
  let(:roller) { cyclist_types.detect { |t| t[:type] == :rouleur } }
  let(:player_details) {
    [
      { name: "Amy", color: :red, cyclists: [sprinter, roller] },
      { name: "Bob", color: :blue, cyclists: [sprinter, roller] },
      { name: "Claire", color: :green, cyclists: [sprinter, roller] },
    ]
  }
  let(:track) {
    FlammeRubuge::TrackBuilder.new(:"One Hill", 3).squares
  }
  let(:subject) {
    FlammeRubuge::Race.new(player_details, track)
  }

  it "basic checks" do
    expect(subject.next_turn).to be_a(FlammeRubuge::Turn)
    expect(subject.players.count).to eq(3)
  end

  it "built track is correct" do
    expect(subject.track.count).to eq(78)
    expect(subject.track.filter(&:start?).count).to eq(5)
    expect(subject.track.filter(&:finish?).count).to eq(5)
  end

  describe "a real turn" do
    before do
      subject.create_starting_grid(:random)
    end

    it "works!" do
      # choosing cards phase
      subject.current_turn.played_cards = {}
      players.each do |player|
        player.cyclists.each do |cyclist|
          hand = cyclist.draw(4)
          turn.played_cards[cyclist] = cyclist.play(hand.first, hand.drop(1))
        end
      end
      expect(turn.played_cards.size).to eq(6)
      expect(turn.played_cards.keys).to all(be_a_kind_of(FlammeRubuge::Cyclist))
      expect(turn.played_cards.values).to all(be_a_kind_of(FlammeRubuge::Card))

      # resolving cards phase
      turn.movement

      # end of turn cleanup
      turn.end
    end
  end

  describe "a pre-ordained start" do
    before do
      starting_grid = [
        players.first.cyclists.first, # Amy sprinter
        players.first.cyclists.last, # Amy rouleur
        players[1].cyclists.first, # Bob sprinter
        players[1].cyclists.last, # Bob rouleur
        players.last.cyclists.first, # Claire sprinter
        players.last.cyclists.last, # Claire rouleur
      ]
      subject.create_starting_grid(:strict_order, starting_grid)
    end

    it "checks for finishers" do
      allow(subject.track[4]).to receive(:finish?).and_return(true)
      expect(subject.check_finishers).to eq(
        [
          players.first.cyclists.first,
          players.first.cyclists.last,
        ]
      )
    end

    it "works" do
      turn.played_cards = {
        players.first.cyclists.first => double(number: 4),
        players.first.cyclists.last => double(number: 4),
        players[1].cyclists.first => double(number: 5),
        players[1].cyclists.last => double(number: 7),
        players.last.cyclists.first => double(number: 2),
        players.last.cyclists.last => double(number: 3),
      }

      expect(subject.players.count).to eq(3)

      expect(subject.track[2].cyclists).to eq(
        [players.last.cyclists.first, players.last.cyclists.last]
      )

      turn.movement
      expect(subject.track[4].cyclists).to eq(
        [players.last.cyclists.first]
      )
      expect(subject.track[5].cyclists).to eq(
        [players.last.cyclists.last]
      )
      expect(subject.track[6].cyclists).to be_empty
      expect(subject.track[7].cyclists).to eq(
        [players[1].cyclists.first]
      )
      expect(subject.track[8].cyclists).to eq(
        [players.first.cyclists.first, players.first.cyclists.last]
      )
      expect(subject.track[9].cyclists).to be_empty
      expect(subject.track[10].cyclists).to eq(
        [players[1].cyclists.last]
      )

      turn.end
      expect(subject.track[5].cyclists).to be_empty
      expect(subject.track[6].cyclists).to eq(
        [players.last.cyclists.first]
      )
      expect(subject.track[7].cyclists).to eq(
        [players.last.cyclists.last]
      )
      expect(subject.track[8].cyclists).to eq(
        [players[1].cyclists.first]
      )
      expect(subject.track[9].cyclists).to eq(
        [players.first.cyclists.first, players.first.cyclists.last]
      )
      expect(subject.track[10].cyclists).to eq(
        [players[1].cyclists.last]
      )
      expect(subject.track[11].cyclists).to be_empty

      # check the exhaustion cards have been handed out
      expect(players[1].cyclists.last.exhaustion_count).to eq(1)
      expect(players.first.cyclists.last.exhaustion_count).to eq(0)
      expect(players.last.cyclists.first.exhaustion_count).to eq(0)
    end
  end

  def players
    subject.players
  end

  def turn
    subject.current_turn
  end
end
