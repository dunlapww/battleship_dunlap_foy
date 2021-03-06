require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/user'
require './lib/computer'

class Game
  attr_accessor :game_start_input, :computer, :user

  def initialize
    @game_start_input = ""
  end


  def display_game_message
    "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.\n"
  end

  def get_user_input
    @game_start_input = gets.chomp.downcase
  end

  def interpret_user_input
    if @game_start_input.downcase == 'p'
      return ""
    elsif @game_start_input.downcase == 'q'
      exit(true)
    else
      return "Sorry, it's not clear what you'd like to do, let's try this again...\n\n"
    end
  end

  def main_menu_loop
    until @game_start_input == 'p' do
      print display_game_message
      get_user_input
      print interpret_user_input
    end
  end

  def get_board_size
    valid = false
    until valid
      print "What size board would you like to play with? [4 - 10]:"
      @board_size = gets.chomp.to_i
      if (4..10).include?(@board_size)
        valid = true
      else
        print "Sorry, invalid board size, I need a number between 4 and 10...\n"
      end
    end
  end


  def play
    inf_loop = true
    while inf_loop do
      main_menu_loop
      @game_start_input = ""
      get_board_size
      @computer = Computer.new(@board_size)
      @user = User.new(@board_size)
      @computer.place_ships
      print "I have laid out my ships on the grid.\n"
      print "You now need to layout your #{@user.ships.size} ships.\n"
      print "The cruiser is three units long and the submarine is two units long.\n"
      print @user.board.render

      @user.place_ships
      print "\n\nLET'S PLAY!\n\n"

      until @user.ships.all? {|ship| ship.sunk?} || @computer.ships.all?{|ship| ship.sunk?}
        display_game_boards
        @user.fire_shot(@computer)
        print computer.fire_shot(@user)
      end
      print display_game_boards
      end_game
      print "How about another round?...\n\n"
    end
  end

  def end_game
    if @user.ships.all? {|ship| ship.sunk?}
      print "I Won!\n"
    else
      print "You won!\n"
    end
  end

  def display_game_boards
    print "=================COMPUTER BOARD=================\n"
    print computer.display_board
    print "==================PLAYER BOARD=================\n"
    print user.display_board(true)
  end

end
