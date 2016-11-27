module Gemometer
  class System
    def self.bundle_outdated
      system('bundle', 'outdated')
    end
  end
end
