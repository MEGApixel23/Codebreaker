require "Codebreaker/version"

module Codebreaker
  class Game
    attr_reader :code, :input_code, :max_tries, :current_try

    MAX_TRIES = 5

    def initialize
      @code, @max_tries, @current_try = '', Game::MAX_TRIES, 0
    end

    def start
      4.times do
        @code << rand(1...6).to_s
      end
    end

    def input_code=(input)
      unless input.kind_of?(Numeric) || input.kind_of?(String)
        raise Exception
      end

      unless input =~ /^[1-6]{4}$/
        raise Exception
      end

      @input_code = input.to_s
    end

    def check_code
      raise Exception 'You must to input code first' if @input_code.empty?
      raise Exception 'Max tries' if @current_try >= @max_tries

      @current_try += 1

      result = ''
      code_copy = @code.clone
      input_code_copy = @input_code.clone

      @input_code.chars.each_with_index do |char, index|
        if char === @code[index]
          result << '+'
          code_copy[index] = '*'
          input_code_copy[index] = '*'
        end
      end

      input_code_copy.chars.each_with_index do |char, index|
        if char != '*'
          index_of_char_in_code = code_copy.index(char)

          if index_of_char_in_code
            result << '-'
            code_copy[index_of_char_in_code] = '*'
            input_code_copy[index] = '*'
          end
        end
      end

      result
    end
  end
end