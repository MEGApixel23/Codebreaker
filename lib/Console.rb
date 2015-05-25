require_relative "Codebreaker"

while true do
  game = Codebreaker::Game.new()
  game.start
  #puts game.code
  puts 'Game starts. Input 4 numbers from 1 to 6'

  i = 0
  while i <= game.max_tries  do
    game.input_code = gets.chomp
    result = game.check_code

    if result === true
      puts 'You win. Type your name'
      game.save_result gets.chomp
      i = game.max_tries
      puts 'Start again? [y/n]'
      abort if (gets.chomp == 'n')
    elsif result === false
      puts 'You loose. Start again? [y/n]'
      abort if (gets.chomp == 'n')
    else
      puts result
      i += 1
    end
  end
end