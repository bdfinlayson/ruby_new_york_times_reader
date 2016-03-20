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
    puts "Would you like to hear this story? (y / n)"
    yes?
  end

  def read_another?
    puts "Would you like to hear another story from this category? (y / n)"
    if yes?
      remove_story_from_list
      continue
    else
      puts "Would you like to choose a different category? (y / n)"
      if yes?
        restart
      else
        puts "Okay! Thanks for listening!"
        abort
      end
    end
  end

  def yes?
    yes_or_no? gets.chomp
  end
end
