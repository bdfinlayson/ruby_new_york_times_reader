require_relative 'categories'

module Parser
  include Categories

  def parse(input)
    raise if not valid? input
  end

  def yes_or_no?(input)
    match? "yes", input
  end

  private

  def valid?(input)
    CATEGORIES.split.each do |category|
      return category if match? category, input
    end
  end

  def match?(obj, input)
    input.downcase!
    obj.start_with?(input) || obj.eql?(input)
  end
end

