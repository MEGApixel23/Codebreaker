require "Codebreaker/version"

module Codebreaker
  class Game
    attr_reader :code
    attr_reader :input_code

    def initialize
      @code = ''
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

    end
  end
end