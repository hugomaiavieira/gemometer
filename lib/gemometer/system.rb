module Gemometer
  class System
    def self.bundle_outdated
      `bundle outdated`
    end
  end
end
