require "simplecov"
SimpleCov.start do
  add_filter "/vendor/"
  add_filter "/bin/"
  add_filter "/exe/"
  add_filter "/spec/"
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gemometer'

Dir["spec/support/**/*.rb"].each { |f| load f }
Dir["spec/shared_examples/**/*.rb"].each { |f| load f }
