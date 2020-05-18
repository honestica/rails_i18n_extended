# RailsI18nExtended

The gem adds a bunch of helpers to ease the use of I18n in your rails project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_i18n_extended'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rails_i18n_extended

## Usage

The following helpers are available:
- `Model.t` will get the model name
- `Model.ts` will get the model name (pluralized)
- `Model.t_action(action_name)` will get localized action
- `Model.t_panel(panel_name)` will get localized panel name
- `Model.t_attr(attr)` will get name of the attribute
- `model.t_attr(attr)` (on an instance) will get name of the attribute
- `model.t_enum(attr)` (on an instance) will get value of an enum attribue, localized

You can also call the method `t` on booleans, or on a string to get its translation as a key.
You can call `l` on all time-related classes to get their localized representation.

We also added a "default fallback" behaviour: when looking for the key `a.b.c.key`, before failing, I18n will look for `a.b.default.key`,  `a.default.key` and  `default.key`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/honestica/rails_i18n_extended.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
