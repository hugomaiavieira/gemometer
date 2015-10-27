module Gemometer
  class Parser
    REGEX=%r(\* ([^\s]+) \(newest ([0-9|\.]+), installed ([0-9|\.]+)\))

    def initialize(str)
      @str  = str
      @gems = []
    end

    def parse
      @str.scan(REGEX){ |a, b, c| @gems << { name: a, newest: b, installed: c } } if @gems.empty?
      @gems
    end
  end
end
