require_relative './gem_array'
require_relative './gem'

module Gemometer
  class Parser
    REGEX=%r(\* ([^\s]+) \(newest ([0-9|\.]+), installed ([0-9|\.]+)[\)|,](?: requested (.*[0-9|\.]+)\) in group "(\w+)")?)

    attr_reader :gems

    def initialize(str)
      @str  = str
      @gems = GemArray.new
    end

    def parse
      if @gems.empty?
        @str.scan(REGEX) do |a, b, c, d, e|
          @gems << Gem.new(name: a, newest: b, installed: c, requested: d, group: e)
        end
      end
    end
  end
end
