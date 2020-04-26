require_relative 'bad_links'
require_relative 'directions'
require 'byebug'

module StoryService
  include BadLinks
  include Directions

  attr_accessor :stories_list, :current_story, :selected_story

  def initialize
    @current_story
  end

  def get_stories_list_from(category)
    begin
      page_links = Nokogiri::HTML(open("http://www.nytimes.com/pages/#{category}/index.html"))
      filter_stories_from page_links, category
    rescue
      puts error_retriving_category
      restart
    end
  end

  def filter_stories_from(page_links, category)
    puts "Finding story links..."

    goodlinks = Array.new

    page_links.css('a').each do |a|
      begin
        raise if a.attributes["href"].nil?
        link = a.attributes["href"].value
        raise if link.length < 50
        raise if link.length > 150
        BADLINKS.each do |bl|
          raise if link.include? bl
          raise if !link.include? category
        end
        goodlinks.push link
      rescue
        # "Skipping link..."
      end
    end
    puts "Found #{goodlinks.uniq!.count} stories to read!"
    goodlinks.shuffle!
  end

  def remove_story_from_list
    @stories_list.delete_if {|story| story.eql? @current_story }
    puts "You have #{@stories_list.count} stories remaining..."
  end

  def list_stories
    @stories_list.each_with_index do |story, index|
      parts = story.split("/").last(2)
      region = parts[0]
      description = parts[1]
      puts "\t" + index.to_s + " -- " + region.upcase + ' -- ' + description.gsub(".html", '').gsub("-", ' ').capitalize
    end

    puts "\n" + "Which story would you like to hear?"

    @selected_story = gets.chomp
  end

  def get_story
    begin
      @current_story = @stories_list[@selected_story.to_i]

      puts "Scraping content now..."

      agent = Mechanize.new { |a| a.user_agent_alias = "Mac Safari" }

      agent.get("https://nytimes.com" + @current_story) do |story|
        headline = story.search("h1[itemprop='headline']").text
        date_published  = story.search("time").first.text
        articleBody = story.search("section[name='articleBody']")
        open("random_story.txt", 'w') do |f|
          f << headline + "\n"
          f << "Published on #{date_published} \n"
          f << " ... \n"
          articleBody.children.each do |el|
            text = el.text
            if text.length < 600 # to filter css / js content
              text.split(". ").each do |t|
                f << t.strip + "\n"
              end
            end
          end
        end
      end
    rescue
      puts "Sorry, there was a problem retrieving your story..."
      read_another?
    end
  end
end
