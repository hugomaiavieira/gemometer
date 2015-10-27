$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gemometer'

Dir["spec/support/**/*.rb"].each { |f| load f }
Dir["spec/shared_examples/**/*.rb"].each { |f| load f }
