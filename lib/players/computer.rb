require 'pry'
class Computer < Player

  def move(board) # we need to pass in the actual game board instance
  #
    player_moves = available_moves(board)
  #  binding.pry
    if check_winning_move(board)
      y = make_winning_move(board)
    #  puts "WINNER"
      y
    elsif check_blocking_move(board)
      z = make_blocking_move(board)
    #  puts "BLOCKED"
      z
    elsif player_moves.count == 9
      m = "5"
      #puts "MIDDLE"
      m
    elsif player_moves.count == 8
      c = ["1", "3", "7", "9"].sample
    #  puts "CORNER"
      c
  #  elsif player_moves.count == 7

    else
      x = player_moves.sample
    #  puts "RANDOM"
      x
    end
  end

  # def corners(board)
  #   if (available_moves(board).include?
  #     ["1", "3", "7", "9"].sample
  #   end
  # end

  def available_moves(board)
    collect_positions(" ", board)
  end


  def collect_positions(token_or_empty, board)
    positions = board.cells.each_index.select {|i| board.cells[i] == token_or_empty}
    positions.collect {|x| (x+1).to_s}
    # return is an array of strings where there are spaces fitting the passed in criteria(token_or_empty)
  end

  def potential_winning_combo_locations(board)    #wincombo to tokens - returns a winning combination as an array of tokens or spaces
    Game::WIN_COMBINATIONS.collect do |combo|
      #binding.pry
  	   combo.collect { |c| c = board.cells[c] }
  	end
  end

  def winning_combos_token_counts(board)
    potential_winning_combo_locations(board).collect do |combo|
      {
      nX: combo.count {|c| c == "X" },
  		nO: combo.count {|c| c == "O" },
  	  nE: combo.count {|c| c == " " }
      }
      #iterate through each winning combination, create a hash with the number of each element in each winning combo.
      # example:  If player 1 goes in position 4, that hash would read
      # [{:nX=>0, :nO=>0, :nE=>3},
      #  {:nX=>1, :nO=>0, :nE=>2},
      #  {:nX=>0, :nO=>0, :nE=>3},
      #  {:nX=>1, :nO=>0, :nE=>2},
      #  {:nX=>0, :nO=>0, :nE=>3},
      #  {:nX=>0, :nO=>0, :nE=>3},
      #  {:nX=>0, :nO=>0, :nE=>3},
      #  {:nX=>0, :nO=>0, :nE=>3}]
    end
  end

  def x_winning_combo(board)
  #  look at the hash.  If there are 2 X's in the hash && an empty space, return that space
  #  binding.pry
    winning_combos_token_counts(board).index {|combo| combo[:nX] == 2 && combo[:nE] == 1}
  end


  def o_winning_combo(board)
  #  look at the hash.  If there are 2 O's in the hash && an empty space, return that space
  #  binding.pry
    winning_combos_token_counts(board).index {|combo| combo[:nO] == 2 && combo[:nE] == 1}
  end

  def check_winning_move(board)
    case @token
    when "X"
      x_winning_combo(board)
    when "O"
      o_winning_combo(board)
    end
  end

  def check_blocking_move(board)
    case @token
    when "X"
      o_winning_combo(board)
    when "O"
      x_winning_combo(board)
    end
  end

  def find_empty_for_win(board)
    Game::WIN_COMBINATIONS[check_winning_move(board)].index do |c|
      board.cells[c] == " "
    end
  end

  def find_empty_for_block(board)
    Game::WIN_COMBINATIONS[check_blocking_move(board)].index {|c| board.cells[c] == " "}
  end


  def make_winning_move(board)
    (Game::WIN_COMBINATIONS[check_winning_move(board)][find_empty_for_win(board)] + 1).to_s
  end

  def make_blocking_move(board)
    (Game::WIN_COMBINATIONS[check_blocking_move(board)][find_empty_for_block(board)] + 1).to_s
  end

end

  # => check for available spaces

  # => check for potential winning moves
  # =>  make 100% of winning moves
  # =>  block potential opponent wins
