class Reader < Application
  def read_story
    begin
      puts "Reading now..."
      count = 0
      File.open('random_story.txt', 'r') do |f|
        f.each_line do |line|
          count += 1
          if count == 3
            raise if not want_to_listen?
          else
            puts line
            `say #{line}`
          end
        end
      end
    rescue
      read_another?
    end
  end
end
