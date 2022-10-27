require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    # Take the array of letters and split them up individually
    @letters = params[:letters].split
    # Take the word you entered and capitalize it
    @word = (params[:word] || "").upcase
    # Check if the word you created is in the letters provided
    @included = included?(@word, @letters)
    # Check if the word is an English word
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    # Take the word submitted (string) and returns it in an array
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
