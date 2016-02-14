module Gemometer
  class Gem
    attr_reader :name, :newest, :installed, :requested, :group

    def initialize(attrs)
      attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    end
  end
end
