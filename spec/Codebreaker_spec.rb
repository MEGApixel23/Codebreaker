require 'spec_helper'
require 'fileutils'

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
        game.input_code = 1234

        expect(game.input_code).not_to be_empty
      end

      it 'checks user code validation' do
        expect{game.input_code = {}}.to raise_exception
        expect{game.input_code = []}.to raise_exception
        expect{game.input_code = ''}.to raise_exception
        expect{game.input_code = 'test data'}.to raise_exception
        expect{game.input_code = '123x'}.to raise_exception
      end
    end

    describe '#check_code' do
      it 'checks code without input it' do
        expect{game.check_code}.to raise_exception
      end

      it 'marks code according to algorithm' do
        game.instance_variable_set :@code, '1234'
        game.input_code = '1235'
        expect(game.check_code).to eq('+++')

        game.instance_variable_set :@code, '1234'
        game.input_code = '5551'
        expect(game.check_code).to eq('-')

        game.instance_variable_set :@code, '1234'
        game.input_code = '1243'
        expect(game.check_code).to eq('++--')
      end

      it 'checks win' do
        game.instance_variable_set :@code, '1234'
        game.input_code = '1234'
        expect(game).to receive(:win)
        game.check_code
      end

      it 'checks loose' do
        game.instance_variable_set :@code, '1234'
        game.input_code = '4321'
        expect(game).to receive(:loose)

        (0...Game::MAX_TRIES).each do
          game.check_code
        end
      end
    end

    describe '#win' do
      it 'sets game_result into win statement' do
        game.send(:win)
        expect(game.instance_variable_get(:@game_result)).to eq(true)
      end
    end

    describe '#loose' do
      it 'sets game_result into loose statement' do
        game.send(:loose)
        expect(game.instance_variable_get(:@game_result)).to eq(false)
      end
    end

    describe '#save_result' do
      tmp_scores_file = File.expand_path('../tmp/scores.json', __FILE__)

      before(:all) do
        game = Game.new
        FileUtils.copy game.instance_variable_get(:@scores_file), tmp_scores_file
      end

      after(:all) do
        game = Game.new
        FileUtils.copy tmp_scores_file, game.instance_variable_get(:@scores_file)
        FileUtils.rm(tmp_scores_file)
      end

      it 'not works if codebreaker has not won' do
        expect{
          game.save_result 'Ivan Ivanov'
        }.to raise_exception

        game.send(:loose)
        expect{
          game.save_result 'Ivan Ivanov'
        }.to raise_exception
      end

      it 'saves user`s name if codebreaker has won' do
        game.send(:win)
        game.save_result 'Ivan Ivanov'

        expect(game.instance_variable_get(:@user_name)).to eq('Ivan Ivanov')
      end

      it 'saves scores and user`s name into file' do
        tested_name = 'Ivan Ivanov ' + Time.now.to_i.to_s
        current_try = 12

        game.instance_variable_set(:@current_try, current_try)
        game.send(:win)
        game.save_result tested_name

        results = File.read(game.instance_variable_get(:@scores_file))
        results = JSON.load results

        has_saved = false
        results.each do |res|
          has_saved = true if res['name'] == tested_name && res['tries'] == current_try
        end

        expect(has_saved).to be(true)
      end

      it 'saves scores by tries sort'
    end

    describe '#hint' do
      it 'gives a number from code in right position' do
        game.hint.chars.each_with_index do |char, index|
          if char != '*'
            expect(game.instance_variable_get(:@code).chars[index]).to eq(char)
          end
        end
      end

      it 'can gives hint only once' do
        game.hint

        expect{game.hint}.to raise_exception
      end
    end

    describe '#get_results' do
      tmp_scores_file = File.expand_path('../tmp/scores.json', __FILE__)

      before(:all) do
        game = Game.new
        FileUtils.copy game.instance_variable_get(:@scores_file), tmp_scores_file
      end

      after(:all) do
        game = Game.new
        FileUtils.copy tmp_scores_file, game.instance_variable_get(:@scores_file)
        FileUtils.rm(tmp_scores_file)
      end

      it 'gives result table' do
        expect(game).to respond_to :get_results
      end

      it 'gives results in string format' do
        expect(game.get_results :raw).to be_a_kind_of String
      end

      xit 'gives results in object format' do
        #@TODO check if score table is empty
        results = game.get_results :object
        expect(results).to be_a_kind_of Array

        results.each do |item|
          expect(item).to be_a_kind_of Object
          expect(item).to have_key 'name'
          expect(item).to have_key 'tries'
        end
      end
    end
  end
end