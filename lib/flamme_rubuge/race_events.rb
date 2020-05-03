module FlammeRubuge
  class Race # :nodoc:
    def move_cyclists(played_cards)
      track.reverse_each_with_index do |square, index|
        square.cyclists.each do |cyclist| # this will often be empty. Is it the right order??
          true_number = modified_card_value(played_cards[cyclist], square, index)
          move(cyclist, true_number, square)
        end
      end
    end

    def assign_exhaustion_cards(immune)
      @track.each_cons(2) do |squares|
        if squares.first.occupied? && squares.last.empty? # rubocop: disable Style/Next
          squares.first.cyclists.each do |cyclist|
            cyclist.add_exhaustion unless immune.include?(cyclist)
          end
        end
      end
    end

    def clean_up_cards(played_cards)
      played_cards.each do |cyclist, card|
        cyclist.played << card
        # The ones that weren't played might be dealt with by cyclist#play
      end
    end

    def apply_slipstreaming
      previous_index = nil
      @squares_to_move = []
      @track.each_with_index do |square, index| # go through track, from the start
        @squares_to_move.clear unless square.slipstream?
        if square.occupied? && square.slipstream? # rubocop: disable Style/Next
          resolve_slipstream(previous_index, index)
          @squares_to_move << { square: square, index: index } # the new square and index
          previous_index = index
        end
      end
    end

    def check_finishers
      finished_cyclists = endzone.map(&:cyclists).flatten
      finished_cyclists.each_with_index { |cyclist, index| cyclist.set_finish_position(index) }
      finished_cyclists
    end

    def remove_finished_cyclists
      endzone.each(&:empty!)
    end

    private

    def endzone
      @track.filter(&:finish?).reverse
    end

    def move(cyclist, modified_card_value, start_square)
      pick_up(cyclist, start_square)
      target_track = track[0..target_index(start_square, modified_card_value)]
      until target_track.last.empty_lane
        target_track.pop # this is inefficient, let's examine the array
        # instead of mutating it all the time
      end
      put_down(cyclist, target_track.last)
    end

    def pick_up(cyclist, square)
      square.lanes.each { |lane| lane.empty! if lane.occupant == cyclist }
    end

    def target_index(start_square, modified_card_value)
      target_index = track.index(start_square) + modified_card_value
      # make sure we don't go off the end of the track
      target_index >= track.size ? track_size : target_index
    end

    # not properly tested
    def modified_card_value(card, square, square_index)
      min_speed = square.min_speed || 0
      lower_bound = [min_speed, card.number].max
      max_speeds = max_values_for_track_range(card.number, square_index)
      (max_speeds + [lower_bound]).compact.min
    end

    def max_values_for_track_range(desired_movement, initial_index)
      desired_movement_squares = @track[initial_index..(initial_index + desired_movement)]
      desired_movement_squares.map(&:max_speed)
    end

    def put_down(cyclist, square)
      square.empty_lane.occupant = cyclist
    end

    # ************ EXPLANATION OF resolve_slipstream *************
    # square_thingy is a hash of sqaure and its index.
    # The index is required so we can work out where the next square forward is.

    # squares_to_move has all the square_thingys that have cyclists we want to slipstream
    # assuming we find something to slipstream behind. If the gap is too big, then our
    # guardy clause will empty the array.

    # after we have moved the cyclists on a square, our new list of squares will be
    # different from what we had to start with. So I put this in squares_to_move_new.

    # Finally, for an as-yet unkown reason, the order of these squares doesn't stay as I would
    # expect (see the example in the turn_spec file). So I make sorted_list as a bodge
    # for this issue, then it all seems to work correctly.

    def resolve_slipstream(occupied_index, index)
      return if occupied_index.nil?
      if index - occupied_index > 2
        @squares_to_move.clear
        return
      end
      # this doesn't work for multiple slipstreams
      # in the example, the cyclists were in squares 8,7,5,4
      # but now they are in 8,7,6,5
      # so when we call it, we find 6 empty and stop iterating.
      @squares_to_move_new = []

      # I don't know how in the test case, it gets out of order.
      # Here is a hack for now
      sorted_list = @squares_to_move.sort_by { |square_thingy| square_thingy[:index] }

      sorted_list.reverse_each { |square_thingy| move_square_forward_one(square_thingy) }

      @squares_to_move = @squares_to_move_new unless @squares_to_move_new.empty?
    end

    def move_square_forward_one(square_thingy)
      index = square_thingy[:index]
      square_to_move = square_thingy[:square]
      target_square = @track[index + 1]

      return unless target_square.empty?

      square_to_move.cyclists.each do |cyclist|
        target_lane = target_square.empty_lane
        square_to_move.remove_cyclist(cyclist)
        target_lane.occupant = cyclist
      end

      @squares_to_move << { square: target_square, index: index + 1 }
    end

    # used for debugging
    def track_update
      @track.each_with_index do |track, index|
        next if track.empty?
        break if index > 10
        puts "track square #{index}"
        track.cyclists.each do |cyclist|
          puts "found cyclist #{cyclist.player.name} #{cyclist.type}"
        end
      end
    end
  end
end
