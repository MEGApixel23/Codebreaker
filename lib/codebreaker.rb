require_relative 'Codebreaker/version'
require 'json'

module Codebreaker
  class Game
    attr_reader :code, :input_code, :max_tries, :current_try, :game_result

    MAX_TRIES = 5

    def initialize
      @code, @max_tries, @current_try = '', Game::MAX_TRIES, 0
      @game_result = nil
      @user_name = ''
      @scores_file = File.expand_path('../scores.json', __FILE__)
      @hint_allowed = true
      @hints = 0
    end

    def start
      4.times do
        @code << rand(1...6).to_s
      end
    end

    def input_code=(input)
      raise Exception unless input.kind_of?(Numeric) || input.kind_of?(String)
      input = input.to_s
      raise 'Code must contain 4 numbers from 1 to 6' unless input =~ /^[1-6]{4}$/
      @input_code = input
    end

    def check_code
      raise Exception 'You must input code first' if @input_code.empty?
      return loose if @current_try >= @max_tries
      return win if @input_code == @code

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

    private
    def win
      @game_result = true
    end

    def loose
      @game_result = false
    end

    public
    def save_result(name)
      raise Exception, 'To save result user must win!' if @game_result != true
      @user_name = name

      results = File.read(@scores_file)
      results = JSON.load results

      results = [] unless results.is_a? Array

      results << {name: name, tries: @current_try}
      File.write(@scores_file, results.to_json)
    end

    def hint
      raise Exception unless @hint_allowed

      needed_index = rand(0...3)
      hint = ''

      @code.chars.each_with_index do |char, index|
        if index == needed_index
          hint << char
        else
          hint << '*'
        end
      end

      @hint_allowed = false
      @hints += 1
      hint
    end
  end
end