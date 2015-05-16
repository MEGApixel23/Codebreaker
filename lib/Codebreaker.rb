require "Codebreaker/version"

module Codebreaker
  class Game
    attr_reader :code

    def initialize
      @code = ''
    end

    def start
      @code = '1234'
    end
  end
end