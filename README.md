# Subjective

Provides a useful interface for exposing contextualizable and contextualized data to user-facing tools. Useful for:

- Building graphical automation tools that provide rudimentary control flow
- Providing consistent, versioned APIs across multiple protocols
- Passing data to a templating tool for simple
- Serializing a snapshot of data for storage

Think of a `Subjective` context as a data schema in reverse. Like a schema, it describes how the data in a data structure is supposed to look. Rather than taking a fully-formed structure and validating against that schema, it takes one or more objects as a "seed", and generates that data structure from those objects.

How is this different from just defining a data object? Subjective gives us a useful abstraction for our data in order to:

- Ensure consistency across all data objects in your application for ease of use and clarity
- Be shared across multiple workflows such that their output can be predictable and flexible
- Provide a well-defined "intentional" interface for empty data

Rather than creating yet another domain-specific language for creating contexts, `Subjective` allows you to plug in the library with which you are already using. Validations can also be accomplished using whatever you are comfortable with, as well. A `Subjective` context will wrap itself around the associated DSLs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'subjective'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subjective

## Usage

Choose the libraries you wish to use up front:

```ruby
Subjective.use :dry_struct
Subjective.validate_with :activemodel
```

Contexts are defined with a class definition:

```ruby
class PurchaseContext < Subjective::Context
  # Notice how we use the `dry-struct` DSL here
  define_schema do
    attribute :item_name, Types::Coercible::String
    attribute :total, Types::Coercible::Float
  end

  # Here, we use the `ActiveModel` validation DSL
  define_validations do
    validates :item_name, presence: true
    validates :total, numericality: { greater_than: 0 }
  end
end
```

A context can be initialized directly:

```ruby
ctx1 = PurchaseContext.new(item_name: 'Health bar', total: 3.13)
ctx2 = PurchaseContext.new(item_name: '', total: 5.42)

ctx1.item_name #=> 'Health bar'
ctx2.total #=> 5.42

ctx1.valid? #=> true
ctx2.valid? #=> false
```

Alternatively, we can define a "seed" to map existing application constructs on to a context:

```ruby
class PurchaseContext < Subjective::Context
  # ...

  seed_with(line_item: LineItem) do
    item_name { line_item.name }
    total { line_item.quantity * line_item.price }
  end
end

ctx = PurchaseContext.materialize_with(line_item: some_line_item)

ctx.total #=> 12.44
```

We can define as many seeds as we like, so long as their keys don't interfere with each other.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/subjective. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Subjective project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/subjective/blob/master/CODE_OF_CONDUCT.md).
