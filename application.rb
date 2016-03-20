require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative 'directions'
require_relative 'story_service'
require_relative 'parser'

class Application
  include Directions
  include StoryService
  include Parser

  attr_accessor :stories_list

  def initialize
    @stories_list
  end

  def restart
    begin
      input = usr_select_category
      desired_category = parse input
      @stories_list = get_stories_list_from desired_category
      continue
    rescue
      puts invalid_category
      retry
    end
  end

  private

  def continue
    get_story
    read_story
    read_another?
  end
end
