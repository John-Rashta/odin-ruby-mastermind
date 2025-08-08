require colorize
require_relative "computer"
# All the game methods
class Game
  include Computer

  def initialize
    @options = %w[blue green red yellow purple light_blue]
  end

  def setup_game
    @goal = randomize_guess(@options, 4)
  end

  def play_round
    current_guess = player_guess(valid_options, 4)
  end

  def game_over(won, final_guess, solution)
  end

  def alternative_method(guess, solution)
    correct_guesses = Array.new(4, "transparent")
    close_guesses = Array.new(4, "transparent")
    guess.each_with_index do |color, index|
      if solution[index].equal?(color)
        correct_guesses[index] = color
        while correct_guesses.count(color) + close_guesses.count(color) > solution.count(color)
          close_guesses[close_guesses.index(color)] = "transparent"
        end
      elsif solution.include?(color)
        close_guesses[index] = color
      end
    end
    format_evaluation(close_guesses, correct_guesses, solution)
  end

  def format_evaluation(close, correct, solution)
    final_evaluation = Array.new(4, "transparent")
    solution.size.times do |num|
      final_evaluation[num] = "yellow" if close[num] != "transparent"
      final_evaluation[num] = "red" if correct[num] != "transparent"
    end
    final_evaluation
  end

  def display_colors(colors)
    colors.each { |color| print "   ".colorize(background: color.to_symb) }
    puts ""
  end

  def check_win?(guess, solution)
    solution.eql?(guess)
  end

  def check_proximity(guess, solution)
    correct, close = evaluate_proximity(guess, solution)
    filter_guesses(correct, close, solution)
  end

  def evaluate_proximity(guess, solution)
    correct_guesses = []
    close_guesses = []
    guess.each_with_index do |color, index|
      correct_guesses.push(color) if color == solution[index]
      close_guesses.push(color) if solution.include?(color)
    end
    [correct_guesses, close_guesses]
  end

  def filter_guesses(correct, close, solution)
    final_close = if solution.uniq.eql?(solution)
                    close.difference(correct)
                  else
                    close.uniq.reduce([]) do |result, uniq_guess|
                      correct.count(uniq_guess) + close.count(uniq_guess) - solution.count(uniq_guess).times do
                        result.push(uniq_guess)
                      end
                    end
                  end
    [correct, final_close]
  end

  def player_guess(valid_options, quantity)
    current_guess = []
    unless current_guess.size.eql?(quantity) && current_guess.all? { |guess| valid_options.include?(guess) }
      current_guess = gets.chomp.split(",")
    end

    current_guess
  end
end
