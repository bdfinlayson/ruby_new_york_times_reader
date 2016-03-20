require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative 'directions'
require_relative 'story_service'

class Application
  include Directions
  include StoryService

  attr_accessor :stories_list

  def initialize
    @stories_list
  end

  def restart
    @stories_list = get_stories_list_from usr_select_category
    continue
  end

  private

  def continue
    get_story
    read_story
    read_another?
  end
end
