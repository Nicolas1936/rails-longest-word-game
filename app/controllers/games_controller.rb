require "open-uri"
require "nokogiri"

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { (65 + rand(26)).chr }
  end

  def score
    @word = params['word'].upcase
    @token = params['token'].upcase

    original_g = original_grid(@word, @token)

    if original_g
      @api_answer = valid_english_world(@word)

      if @api_answer
        @answer = 1
        # @answer = "Congratulations! #{word} is a valid English word!!!"
      else
        @answer = 2
        # @answer = "Sorry but #{word} does not seem to be a valid English word..."
      end
    else
      @answer = 3
      # @answer = "Sorry but #{word} can't be buil out of #{token.chars.join(", ")}"
    end


    # The word can’t be built out of the original grid
    # The word is valid according to the grid, but is not a valid English word
    # The word is valid according to the grid and is an English word

  end

  private

  def original_grid(word, letters)
    unique = true
    word.chars.each do |word_char|
      if letters.chars.include?(word_char) && unique
        index = letters.chars.index(word_char)
        letters.slice!(index)
      else
        unique = false
      end
    end
    unique
  end

  def valid_english_world(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    JSON.parse(user_serialized)["found"]
  end

end
