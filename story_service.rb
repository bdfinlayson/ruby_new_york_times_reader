require_relative 'bad_links'

module StoryService
  include BadLinks
  attr_accessor :stories_list, :current_story

  def initialize
    @current_story
  end

  def get_stories_list_from(category)
    page = Nokogiri::HTML(open("http://www.nytimes.com/pages/#{category}/index.html"))

    goodlinks = Array.new

    puts "Finding story links..."

    page.css('a').each do |a|
      begin
        raise if a.attributes["href"].nil?
        link = a.attributes["href"].value
        raise if link.length < 50
        raise if link.length > 150
        BADLINKS.each do |bl|
          raise if link.include? bl
        end
        goodlinks.push link
      rescue
        # "Skipping link..."
      end
    end
    goodlinks.uniq!
    puts "Found #{goodlinks.count} stories to read!"
    goodlinks
  end

  def remove_story_from_list
    @stories_list.delete_if {|story| story.eql? @current_story }
    puts "You have #{@stories_list.count} stories remaining..."
  end

  def get_story
    begin
      @current_story = @stories_list.sample
      puts "Here is your random story! #{@current_story}"
      puts "Scraping content now..."
      agent = Mechanize.new { |a| a.user_agent_alias = "Mac Safari" }

      agent.get(@current_story) do |p|
        headline = p.search("#headline")
        date_published  = p.search("time[itemprop='datePublished']").children.text.split(',').first
        story = p.search(".story-body-text")
        open("random_story.txt", 'w') do |f|
          f << headline.children.text + "\n"
          f << "Published on #{date_published} \n"
          f << " ... \n"
          story.each do |story_body|
            f << story_body.children.text + "\n"
          end
        end
      end
    rescue
      puts "Sorry, there was a problem retrieving your story..."
      read_another?
    end
  end
end
