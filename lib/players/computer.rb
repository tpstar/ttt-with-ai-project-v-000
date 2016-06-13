require 'pry'
class Computer < Player

  def move(board) # we need to pass in the actual game board instance
  #  binding.pry
    # if @token == "X" && game.board.turn_count == 0
    #   ["1", "3", "7", "9"].sample
    # else
     ["1", "2", "3", "4", "5", "6", "7", "8", "9"].sample #shit's random yo 
    # end
  end

end


# describe 'Player::Computer' do
#   it 'inherits from Player' do
#     expect(Player::Computer.ancestors).to include(Player)
#   end
#
#   describe '#move' do
#     it 'returns a valid position for the computer to move' do
#       computer = Player::Computer.new("X")
#       board = Board.new
#
#       valid_moves = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
#
#       computer_move = computer.move(board)
#
#       expect(valid_moves).to include(computer_move)
#     end
#   end
# end
