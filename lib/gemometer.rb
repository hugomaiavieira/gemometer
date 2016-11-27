require "gemometer/version"

require 'gemometer/errors'

require "gemometer/system"
require "gemometer/parser"

require "gemometer/notifiers/base"
require "gemometer/notifiers/hipchat"
require "gemometer/notifiers/slack"
require "gemometer/notifiers/mailgun"

module Gemometer
  def self.notifiers
    @notifiers ||= (Notifiers.constants - [:Base]).map{ |n| n.to_s.downcase }
  end
end
