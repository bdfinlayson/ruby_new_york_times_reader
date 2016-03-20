require_relative 'categories'
require_relative 'parser'

module Directions
  include Categories
  include Parser

  def usr_select_category
    puts "Please choose a category:"
    print CATEGORIES
    gets.chomp
  end

  def want_to_listen?
    "Would you like to hear this story? (y / n)"
  end

  def hear_another?
    "Would you like to hear another story from this category? (y / n)"
  end

  def choose_different_story?
    "Would you like to choose a different category? (y / n)"
  end

  def goodbye
    "Okay! Thanks for listening!"
  end

  def invalid_category
    "Sorry, that is an invalid category. Please try again."
  end

  def error_retrieving_story
    "Sorry, there was an error retrieving this story..."
  end

  def error_retriving_category
    "Sorry, there was an error retrieving information for that category."
  end
end
