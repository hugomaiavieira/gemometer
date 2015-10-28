module Gemometer
  class Parser
    REGEX=%r(\* ([^\s]+) \(newest ([0-9|\.]+), installed ([0-9|\.]+)[\)|,](?: requested (.*[0-9|\.]+)\) in group "(\w+)")?)

    def initialize(str)
      @str  = str
      @gems = []
    end

    def parse
      if @gems.empty?
        @str.scan(REGEX) do |a, b, c, d, e|
          @gems << { name: a, newest: b, installed: c, requested: d, group: e }
        end
      end
      @gems
    end
  end
end
