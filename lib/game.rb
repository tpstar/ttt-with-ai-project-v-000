require 'benchmark'
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

    game_mode = gets.strip.downcase
    case game_mode
    when "2"
      two_player_mode
    when "1"
      one_player_mode
      start
    when "0"
      computer_mode
    when "exit"
      exit
    else
      puts "Please enter a valid response."
      start
    end
  end

  def two_player_mode
    game = Game.new(Human.new("X"), Human.new("O"))
    game.play
    start
  end

  def computer_mode
    reps = 0
    puts "Wargames simulation? y or n"
    @war_mode = gets.strip.downcase

    if @war_mode == "y"
      puts " "
      puts "How many simulations?  Enter a number between 1 - 1000:"
      until reps.between?(1, 100000)
        reps = gets.strip.to_i
      end
      time = Benchmark.realtime {wargames(reps)}
      puts "Time elapsed #{time} seconds"
    #  wargames(reps)
      start

    elsif @war_mode == "n"
      Game.new(Computer.new("X"), Computer.new("O")).play
      start
    else
      computer_mode
    end
  end

  def one_player_mode
    puts "Would you like to be Player 1 or Player 2?"

    player_select = gets.strip.downcase
    if player_select == "1"
      puts "Bring it, Human."
      game = Game.new(Human.new("X"), Computer.new("O"))
      game.play
    elsif player_select == "2"
      puts "You're on, bipedal organic sentient being."
      game = Game.new(Computer.new("X"), Human.new("O"))
      game.play
    else
      puts "Enter 1 or 2"
      one_player_mode
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

  def wargames(reps)
    #reps = 1000

    player_1_wins = 0
    player_2_wins = 0
    draw = 0

    # puts "How many matches would you like to run? Enter a number between 1 and 1,000:"
    # reps = gets.strip.to_i
    # if reps.between?(1..1000)

      reps.times do
        game = Game.new(Computer.new("X"), Computer.new("O"))
        game.wargames_play
        if game.winner == "X"
          player_1_wins += 1
        elsif game.winner == "O"
          player_2_wins += 1
        elsif game.draw?
          draw +=1
        end
      end

    p1_percent = player_1_wins * 100.0 / reps
    p2_percent = player_2_wins * 100.0 / reps
    draw_percent = draw * 100.0 / reps
    puts "After #{reps} matches:"
    puts "Player 1 won #{p1_percent}% of the games."
    puts "Player 2 won #{p2_percent}% of the games."
    puts "The outcome was a draw #{draw_percent}% of the games."
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
    puts "Please enter a position on the board 1-9:"
    input = current_player.move(board) #pass in the actual game board for #move method
    if board.valid_move?(input)
      board.update(input, current_player)
      board.display
    else
      turn and return
    end
  end

  def play
    board.display
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

  def wargames_turn
    input = current_player.move(board)
    if board.valid_move?(input)
      board.update(input, current_player)
    else
      wargames_turn and return
    end
  end

  def wargames_play
    until over?
      wargames_turn
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
