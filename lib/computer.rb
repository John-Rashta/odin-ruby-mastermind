# Module with all the computer methods
module ComputerActions
  def randomize_guess(options, quantity)
    final_guess = []
    quantity.times { final_guess.push(options.sample) }

    final_guess
  end
end
