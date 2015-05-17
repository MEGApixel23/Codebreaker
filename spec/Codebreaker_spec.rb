require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) do
      game = Game.new
      game.start
      game
    end

    describe '#start' do
      it 'generates secret code' do
        expect(game.instance_variable_get(:@code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(game.code.length).to be(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.code).to match(/^[1-6]+$/)
      end

      it 'checks code randomization' do
        another_game = Game.new
        another_game.start

        expect(game.code).not_to eq(another_game.code)
      end
    end

    describe '#input_code' do
      it 'take a guess and inputs code' do
        game.input_code = '1234'

        expect(game.input_code).not_to be_empty
      end

      it 'checks user code validation' do
        expect{game.input_code = {}}.to raise_exception
        expect{game.input_code = []}.to raise_exception
        expect{game.input_code = ''}.to raise_exception
        expect{game.input_code = 'test data'}.to raise_exception
      end
    end
  end
end