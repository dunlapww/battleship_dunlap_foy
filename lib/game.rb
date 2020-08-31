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
      # exit will take user back to terminal.
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

  def play
    inf_loop = true
    while inf_loop do
      main_menu_loop
      @game_start_input = ""
      @computer = Computer.new
      @user = User.new

      @computer.place_ships
      print "I have laid out my ships on the grid.\n"
      print "You now need to layout your #{@user.ships.size} ships.\n"
      print "The cruiser is three units long and the submarine is two units long.\n"
      print @user.board.render

      @user.place_ships

      until @user.ships.all? {|ship| ship.sunk?} || @computer.ships.all?{|ship| ship.sunk?}
        display_game_boards
        user_shot
        computer_shot
      end
      end_game
    end
  end

  def end_game
    if @user.ships.all? {|ship| ship.sunk?}
      print "I Won!\n"
    else
      print "You won!\n"
    end
    main_menu_loop
  end

  def computer_shot
    avail_cells = @user.untargeted_cells
    computer_target = avail_cells.sample
    @user.is_fired_upon(computer_target)
    print "My shot on #{computer_target} was a ???\n"
  end

  def user_shot
    valid = false
    print "Enter the coordinate for your shot:"
    until valid == true do
      coord = gets.chomp
      if computer.valid_coordinate?(coord)
        if computer.already_shot?(coord)
          print "You've already shot at #{coord}, please enter a different coord:"
        else
          valid = true
          computer.is_fired_upon(coord)
        end
      else
        print "'#{coord}' is an invalid coord, please enter a valid coordinate:"
      end
    end
    print "Your shot on #{coord} was a ???\n"
  end

  def display_game_boards
    print "=================COMPUTER BOARD=================\n"
    print computer.display_board
    print "==================PLAYER BOARD=================\n"
    print user.display_board(true)
  end

end
