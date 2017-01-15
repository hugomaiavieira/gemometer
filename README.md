# Gemometer

Gemometer is intended to be used on your continuous integration server to notify when there are new versions of the gems used on your project. It is a primitive and free [Gemnasium](https://gemnasium.com).

[![build status](https://gitlab.com/hugomaiavieira/_gemometer/badges/master/build.svg)](https://gitlab.com/hugomaiavieira/_gemometer/commits/master)
[![code climate](https://codeclimate.com/github/hugomaiavieira/gemometer/badges/gpa.svg)](https://codeclimate.com/github/hugomaiavieira/gemometer)
[![coverage report](https://gitlab.com/hugomaiavieira/_gemometer/badges/master/coverage.svg)](http://hugomaiavieira.gitlab.io/_gemometer)

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

To get the help you can do a `gemometer --help`.

### [Hipchat](https://www.hipchat.com)

Log into hipchat.com, go to **Rooms**, select the room and go to **Integrations**, then click on "Build Your Own integration".

    $ gemometer hipchat --url https://url-from-hipchat

### [Slack](https://slack.com)

Log into slack.com, on the "Channel settings" go to **Add an app or integration** and add a "Incoming WebHooks".

    $ gemometer slack --url https://url-from-slack

### [Mailgun](https://mailgun.com)

On mailgun, your first 10,000 emails are free every month. More than enough to notify you about your outdated gems ;)

Follow the instructions to add a domain. When its state became "Active", go to the domains page ("Domains" and click on the domain name) to get the **API Key** and use like this:

    $ gemometer mailgun --domain your-domain.com --key <API Key> --to some@mail.com,other@mail.com

## Examples

### Using on GitLab CI

Add needed [secret variables](http://docs.gitlab.com/ee/ci/variables/README.html#secret-variables) (Hipchat URL for example). Then, add this to your *.gitlab-ci.yml*:

``` yml
gemometer:
  stage: deploy
  allow_failure: true
  script:
    - gemometer hipchat -u "$HIPCHAT_URL"
  only:
    - master
```

### Using on Codeship

On Codeship, you can add this line on your test settings:

``` bash
if [[ "$CI_BRANCH" = 'master' ]]; then gemometer hipchat -u https://url-from-hipchat; else true; fi
```

This will run the gemometer only on `master` branch builds.

**Note**: The most important output of your CI should be the last one, so it's a good idea to do this before the tests commands.

### Outputs

On Hipchat, the output will be like this:

![Hiptchat output](https://cloud.githubusercontent.com/assets/73012/14174061/6b3281d0-f718-11e5-94d3-2b20f750ee90.png)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hugomaiavieira/gemometer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

