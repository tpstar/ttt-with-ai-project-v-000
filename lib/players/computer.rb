require 'pry'
class Computer < Player

  def move(board) # we need to pass in the actual game board instance

    @board = board
    player_moves = available_moves
    if check_winning_move
      y = make_winning_move
    elsif check_blocking_move
      z = make_blocking_move
    elsif player_moves.count == 9
      m = "5"
    elsif player_moves.count == 8
      c = ["1", "3", "7", "9"].sample
    elsif potential_winning_array
      potential_winning_move
    else
      x = player_moves.sample
    end
  end

  def available_moves
    collect_positions(" ")
  end

  def collect_positions(token_or_empty)
    positions = @board.cells.each_index.select {|i| @board.cells[i] == token_or_empty}
    positions.collect {|x| (x+1).to_s}
    # return is an array of strings where there are spaces fitting the passed in criteria(token_or_empty)
  end

  def potential_winning_combo_locations    #wincombo to tokens - returns a winning combination as an array of tokens or spaces
    Game::WIN_COMBINATIONS.collect do |combo|
      #binding.pry
  	   combo.collect { |c| c = @board.cells[c] }
  	end
  end

  def winning_combos_token_counts
    potential_winning_combo_locations.collect do |combo|
      {
      nX: combo.count {|c| c == "X" },
  		nO: combo.count {|c| c == "O" },
  	  nE: combo.count {|c| c == " " }
      }
    end
  end

  def x_winning_combo
    winning_combos_token_counts.index {|combo| combo[:nX] == 2 && combo[:nE] == 1}
  end


  def o_winning_combo
  #  look at the hash.  If there are 2 O's in the hash && an empty space, return that space
    winning_combos_token_counts.index {|combo| combo[:nO] == 2 && combo[:nE] == 1}
  end

  def x_potential_winning_combo
    winning_combos_token_counts.index {|combo| combo[:nX] == 1 && combo[:nE] == 2}
  end

  def o_potential_winning_combo
    winning_combos_token_counts.index {|combo| combo[:nO] == 1 && combo[:nE] == 2}
  end

  def potential_winning_array
    case @token
    when "X"
      x_potential_winning_combo
    when "O"
      o_potential_winning_combo
    end
  end

  def find_potential_empty_move
    potential_array = Game::WIN_COMBINATIONS[potential_winning_array]
    binding.pry
    if @board.cells[potential_array[0]] == " "
      0
    elsif @board.cells[potential_array[2]] == " "
      2
    else
      1
    end
  end

  def potential_winning_move
    (Game::WIN_COMBINATIONS[potential_winning_array][find_potential_empty_move] + 1).to_s
  end

  def check_winning_move
    case @token
    when "X"
      x_winning_combo
    when "O"
      o_winning_combo
    end
  end

  def check_blocking_move
    case @token
    when "X"
      o_winning_combo
    when "O"
      x_winning_combo
    end
  end

  def find_empty_for_win
    Game::WIN_COMBINATIONS[check_winning_move].index do |c|
      @board.cells[c] == " "
    end
  end

  def find_empty_for_block
    Game::WIN_COMBINATIONS[check_blocking_move].index {|c| @board.cells[c] == " "}
  end


  def make_winning_move
    (Game::WIN_COMBINATIONS[check_winning_move][find_empty_for_win] + 1).to_s
  end

  def make_blocking_move
    (Game::WIN_COMBINATIONS[check_blocking_move][find_empty_for_block] + 1).to_s
  end

end
