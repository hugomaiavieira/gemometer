def mock_bundle_outdated_some
  str = %(
Fetching gem metadata from https://rubygems.org/........
Fetching version metadata from https://rubygems.org/..
Resolving dependencies...

Outdated gems included in the bundle:
  * aws-sdk (newest 2.1.32, installed 1.66.0, requested = 1.66.0) in group "default"
  * byebug (newest 6.0.2, installed 5.0.0, requested ~> 5.0.0) in group "development"
  * shoulda (newest 3.0.1, installed 2.8.0, requested ~> 2.8) in group "test"
  * minitest (newest 5.8.2, installed 5.8.1)
  * multi_json (newest 1.11.2, installed 1.9.3)
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
