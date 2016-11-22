module Gemometer
  class Gem
    attr_reader :name, :newest, :installed, :requested, :group

    def initialize(attrs)
      attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def message_line
      "(newest #{newest}, installed #{installed}#{requested_msg})#{group_msg}"
    end

    private

    def requested_msg
      requested ? ", requested: #{requested}" : ""
    end

    def group_msg
      group ? " in group \"#{group}\"" : ""
    end
  end
end
