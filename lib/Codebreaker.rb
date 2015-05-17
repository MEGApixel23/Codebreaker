require "Codebreaker/version"

module Codebreaker
  class Game
    attr_reader :code

    def initialize
      @code = ''
    end

    def start
      4.times do
        @code << rand(1...6).to_s
      end
    end
  end
end