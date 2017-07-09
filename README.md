# humanize_fraction [![CircleCI](https://circleci.com/gh/6/humanize_fraction.svg?style=svg)](https://circleci.com/gh/6/humanize_fraction) [![Gem Version](https://badge.fury.io/rb/humanize_fraction.svg)](https://rubygems.org/gems/humanize_fraction)

Rubygem to convert fraction to words, like 1 ⅓ => one and a third. Examples:

```ruby
"1/8".humanize_fraction
#=> "one eighth"
"1/8".humanize_fraction(shorthand: true)
#=> "an eighth"
"-2 3/4".humanize_fraction
#=> "negative two and three fourths"
"-2 3/4".humanize_fraction(quarter: true)
#=> "negative two and three quarters"
"1/1000000".humanize_fraction(shorthand: true)
#=> "a millionth"
"222/333".humanize_fraction
#=> "two hundred and twenty-two three hundred thirty-thirds"
"1/1000000000000000000000000000".humanize_fraction(shorthand: true)
#=> "an octillionth"
```

If you don't want to monkey patch `String`, you can also use the Humanizer class directly:

```ruby
# From a string:
fraction = HumanizeFraction::Humanizer.from_string("2 1/4")

# From integers:
fraction = HumanizeFraction::Humanizer.new(
  whole_part: 2,
  numerator: 1,
  denominator: 4,
)

fraction.to_s
# => "two and one fourth"

fraction.to_s(shorthand: true, quarter: true)
# => "two and a quarter"
```

## Installation

Add this line to your application's Gemfile and execute `bundle` to install:

```ruby
gem 'humanize_fraction'
```

If you wish to use the monkey-patched `String#humanize_fraction`, add the following into an initializer/config:

```ruby
require 'humanize_fraction'
String.include(CoreExtensions::String::HumanizeFraction)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
