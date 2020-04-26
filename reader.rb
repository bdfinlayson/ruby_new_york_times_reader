require_relative "directions"
require_relative "application"

class Reader < Application
  include Directions

  def read_story
    begin
      puts "Reading now..."
      count = 0
      File.open('random_story.txt', 'r') do |f|
        if f.size < 1000
          puts error_retrieving_story
          raise
        end
        f.each_line do |line|
          count += 1
          puts line
          `say -v Samantha #{line}`
        end
      end
    rescue SystemExit, Interrupt
      read_another?
    end
  end

  def read_another?
    puts "\n"
    puts hear_another?
    if yes?
      remove_story_from_list
      continue
    else
      puts choose_different_story?
      if yes?
        restart
      else
        puts goodbye
        abort
      end
    end
  end
end
