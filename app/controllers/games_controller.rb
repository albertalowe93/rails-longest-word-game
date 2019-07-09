require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters = @letters.join(',')
  end

  def score
    @answer = params[:word]
    @letters = params[:grid]
    if from_grid?(@answer, @letters)
      if english_word?(@answer)
        @message = "Congratulations! #{@answer} is a valid English word."
      else
        @message = "Sorry, but #{@answer} does not seem to be an English word..."
      end
    else
      @message = "Sorry, but #{@answer} can't be built from #{@letters}."
    end
  end

  def from_grid?(answer, letters)
    answer.chars.all? do |letter|
      answer.count(letter) <= letters.downcase.count(letter)
    end
  end

  def english_word?(answer)
    response = open("https://wagon-dictionary.herokuapp.com/#{answer}").read
    json = JSON.parse(response)
    json['found']
  end

  # def compute_score(answer)
  #   @score = answer.size*answer.size
  #   // send the score back to the method score to display in view
  # end
end
