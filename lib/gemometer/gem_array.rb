module Gemometer
  class GemArray < Array
    def listed
      self.class.new(select(&:group))
    end
  end
end
