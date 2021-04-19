# frozen_string_literal:true

# Contains text, board and prompts to display
module Display
  def display_intro
    puts 'Welcome to Hangman.'
  end

  def display_board
    puts <<~BOARD

      |-----+
      |     |
      |     #{@stick_figure[0]}
      |    #{@stick_figure[2]}#{@stick_figure[1]}#{@stick_figure[3]}
      |   #{@stick_figure[7]} #{@stick_figure[4]} #{@stick_figure[8]}
      |    #{@stick_figure[5]} #{@stick_figure[6]}
      |   #{@stick_figure[9]}   #{@stick_figure[10]}

      #{@correct_guesses}
      All guesses so far: #{@all_guesses.join}

    BOARD
  end

  def display_input_prompt
    puts 'Please enter your guess: '
  end

  def display_invalid_input
    puts 'Invalid input or letter guessed already, please try again.'
  end

  def display_correct_letter
    puts "Yes! #{@guess} is a letter in the word!"
  end

  def display_incorrect_letter
    puts "Unfortunately #{@guess} is not a correct letter."
  end

  def display_won_game
    puts "You won! The word was #{@word.join}."
  end

  def display_lost_game
    display_board
    puts "You lost, the word was #{@word.join}."
  end
end

# Contains main game logic which plays a round of hangman with a randomly chosen word
class Hangman
  include Display

  def initialize
    @stick_figure = ['O', '|', '/', '\\', '|', '/', '\\', '^', '^', '^', '^']
    @word = File.readlines('dictionary.txt').delete_if { |word| !word.length.between?(7, 14) }
    @word = @word.sample.downcase.chomp.split(//)
    @correct_guesses = '_' * @word.length
    @all_guesses = []
    display_intro
  end

  def play
    10.downto(0) do |num|
      display_board
      @all_guesses << @guess = player_input
      redo if correct_guess? && @correct_guesses != @word.join
      return display_won_game if @correct_guesses == @word.join

      incorrect_guess(num)
      return display_lost_game if num.zero?
    end
  end

  def player_input
    display_input_prompt
    input = gets.chomp.strip.downcase
    return input if input.match?(/^[a-z]$/) && !@all_guesses.include?(input)

    display_invalid_input
    player_input
  end

  def correct_guess?
    return false unless @word.include?(@guess)

    display_correct_letter
    @word.each_with_index do |letter, index|
      @correct_guesses[index] = @guess if letter == @guess
    end
    true
  end

  def incorrect_guess(num)
    display_incorrect_letter
    @stick_figure[num] = ' '
  end
end

game = Hangman.new
game.play
