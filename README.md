# Gemometer

Gemometer is intended to be used on your continuous integration server to notify when there are new versions of the gems used on your project. It is a primitive and free [Gemnasium](https://gemnasium.com).

[![Codeship Status](https://codeship.com/projects/10d2cd20-6eee-0133-5b8c-0a30d41a0376/status?branch=master)](https://codeship.com/projects/116050)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gemometer', group: :test, require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gemometer

## Usage

### Hipchat

Log into hipchat.com, go to **Rooms**, select the room and go to **Integrations**, then click on "Build Your Own integration".

    $ gemometer --notifier hipchat --url https://url-from-hipchat

### Slack

Log into slack.com, go to **Integrations** (or Configure Integrations) and add a "Incoming WebHooks"

    $ gemometer --notifier slack --url https://url-from-slack

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Examples

### Using on Codeship

On Codeship, you can add this line on your test settings:

``` bash
if [[ "$CI_BRANCH" = 'master' ]]; then gem install gemometer && gemometer -n hipchat -u https://url-from-hipchat; else true; fi
```

This will run the gemometer only on `master` branch builds. 

**Note**: The most important output of your CI should be the last one, so it's a good idea to do this before the tests commands.

### Outputs

On Hipchat, the output will be like this:

![Hiptchat output](https://cloud.githubusercontent.com/assets/73012/14174061/6b3281d0-f718-11e5-94d3-2b20f750ee90.png)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hugomaiavieira/gemometer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

