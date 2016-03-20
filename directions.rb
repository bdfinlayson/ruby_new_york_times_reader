module Directions
  def usr_select_category
    directions = <<-EOS
    Please choose a category:
      business
      health
      national
      opinion
      politics
      science
      technology
      world
    EOS
    print directions
    gets.chomp
  end

  def want_to_listen?
    puts "Would you like to hear this story? (y / n)"
    answer = gets.chomp
    answer.eql?('y')
  end

  def read_another?
    puts "Would you like to hear another story from this category? (y / n)"
    answer = gets.chomp
    if answer.eql? 'y'
      remove_story_from_list
      continue
    else
      puts "Would you like to choose a different category? (y / n)"
      answer = gets.chomp
      if answer.eql? 'y'
        restart
      else
        puts "Okay! Thanks for listening!"
        abort
      end
    end
  end
end
