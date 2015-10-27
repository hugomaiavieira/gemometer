def mock_bundle_outdated_some
  str = %(
Fetching gem metadata from https://rubygems.org/........
Fetching version metadata from https://rubygems.org/..
Resolving dependencies...

Outdated gems included in the bundle:
  * byebug (newest 6.0.2, installed 5.0.0)
  * rspec-rails (newest 0.10.3, installed 0.10.2)
  * some_gem (newest 4.2.0, installed 3.6.0)
)
  allow(Gemometer::System).to receive(:bundle_outdated).and_return(str)
end


def mock_bundle_outdated_none
  str = %(
Fetching gem metadata from https://rubygems.org/............
Fetching version metadata from https://rubygems.org/..
Resolving dependencies...

Bundle up to date!
)
  allow(Gemometer::System).to receive(:bundle_outdated).and_return(str)
end
