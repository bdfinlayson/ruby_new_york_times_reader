require_relative 'categories'

module Parser
  include Categories

  def parse(input)
    raise if not valid? input
  end

  def yes?
    yes_or_no? gets.chomp
  end

  private

  def yes_or_no?(input)
    match? "yes", input
  end


  def valid?(input)
    CATEGORIES.split.each do |category|
      return category if match? category, input
    end
    raise
  end

  def match?(obj, input)
    input.downcase!
    obj.start_with?(input) || obj.eql?(input)
  end
end

