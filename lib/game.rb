require 'pry'
class Game

  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [6, 4, 2]
  ]

  def initialize(player_1 = Human.new("X"), player_2 = Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board if board
  end

  def start
    puts "Hello.  Welcome to Tic Tac Toe."
    puts "Select the number of players:"
    puts "2 for a 2-player game mode"
    puts "1 to test yourself against the computer"
    puts "0 to to have the computer play against itself"
    puts "exit to quit"
    game_mode = gets.strip.downcase

    case game_mode

    when "2"
      game = Game.new(Human.new("X"), Human.new("O"))
      game.play
      start

    when "1"
      puts "Would you like to be Player 1 or Player 2? Enter 1 or 2"
      player_select = gets.strip.downcase
      if player_select == "1"
        game = Game.new(Human.new("X"), Computer.new("O"))
        game.play
      elsif player_select == "2"
        game = Game.new(Computer.new("X"), Human.new("O"))
        game.play
      else
        puts "Enter 1 or 2"
      end

      start
    when "0"
      puts "Wargames simulation? y or n"
      @war_mode = gets.strip.downcase
      if @war_mode == "y"
        wargames
        start
      elsif @war_mode == "n"
        Game.new(Computer.new("X"), Computer.new("O")).play
        start
      end
      when "exit"
      exit
    else
      puts "enter a valid response"
      start
    end
  end

  def current_player
    board.turn_count % 2 == 0 ? player_1 : player_2
  end

  def over?
    won? || draw?
  end

  def draw?
    board.full? && !won?
  end

  def wargames
    player_1_wins = 0
    player_2_wins = 0
    draw = 0

    100.times do
      game = Game.new(Computer.new("X"), Computer.new("O"))
      game.play
      if game.winner == "X"
        player_1_wins += 1
      elsif game.winner == "O"
        player_2_wins += 1
      elsif game.draw?
        draw +=1
      end
    end
    puts ""
    puts "Player 1 won #{player_1_wins}% of the games."
    puts "Player 2 won #{player_2_wins}% of the games."
    puts "The outcome was a draw #{draw}% of the games."
    puts ""
    puts ""
  end


  def won?
    WIN_COMBINATIONS.each do |win_combo|
      if board.cells[win_combo[0]] == "X" && board.cells[win_combo[1]] == "X" && board.cells[win_combo[2]] == "X" ||
         board.cells[win_combo[0]] == "O" && board.cells[win_combo[1]] == "O" && board.cells[win_combo[2]] == "O"
          @winner = board.cells[win_combo[0]]
          return board.cells[win_combo[0]]
           #returns the contents of that location on the board, not the location, used for #winner?
      end
    end
    nil
  end

  def winner
    won?
  end

  def turn
    #board.display
    # if current_player is of Computer class?
    puts "Please enter a position on the board 1-9:"
    input = current_player.move(board) #pass in the actual game board for #move method
    if board.valid_move?(input)
      board.update(input, current_player)
      board.display #unless @war_mode == "y"
    else
      turn and return
    end
  end

  def play
    board.display #unless @war_mode == "y"
    until over?
      turn
    end

    if won?
      puts ""
      puts "Congratulations #{winner}!"
      puts ""
    elsif draw?
      puts "Cats Game!"
    end
  end
end


# The `Game` class is the main model of the application and represents a singular
# instance of a Tic Tac Toe session.
#
#   * A game has one `Board` through its `board` property.
#   * A game has two `Player`s stored in a `player_1` and `player_2` property.
#
# `Board` and `Player` do not directly relate to the `Game` but do collaborate
#   with each other through arguments.

# Beyond providing relationships with players and a board, the `Game`
# instance must also provide the basic game runtime and logic. These methods
# relate to the state of the game such as `#current_player`, `#won?`, and `#winner`.
# The other methods relate to managing a game, like `#start`, `#play`, and `#turn`.
# The test suite describes the method requirements.
