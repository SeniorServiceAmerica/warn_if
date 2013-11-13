# WarnIf

WarnIf provides you with validation warnings on your ActiveRecord
models. Unlike errors, warnings do not prevent the record from saving.

## Installation

Add this line to your application's Gemfile:

    gem 'warn_if'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install warn_if

## Usage

Include WarnIf in any models you want to have warnings on.

  class MyModel < ActiveRecord::Base
    Include WarnIf

    warn_if :condition => :warning_triggered?,
            :on => :update,
            :message => "Hey, you might want to check this."

    warn_if :condition => Proc.new {|m| m.this && m.that},
            :message => "This and that are true, are you sure?"

    warn_if :condition => :this_and_that_and_the_other_thing?
            :message => :special_message

    def warning_triggered?
      ...
    end

    def this_and_that_and_the_other_thing?
      ...
    end

    def special_message
      "This is #{this} and that is #{that} but the other thing is #{other_thing}"
    end
    ...
  end

Then give it a try.

    m = MyModel.first
    m.valid? => true
    m.warned? => true
    m.warnings => {:base => "This and that are true, are you sure?"}
  
### Adding Warnings

Adding and working with warnings works the same as working with the
Errors collection in ActiveModel:

    @it = MyModel.new
    @it.warnings.add(:foo, "Uh oh") => ["Uh oh"]
    @it.warnings[:foo] = "Now you've done it" => ["Uh oh", "Now you've done it"]
    @it.warnings.add("foo", "Again?") => ["Uh oh", "Now you've done it", "Again?"]
    @it.warnings["foo"] = "Still" => ["Uh oh", "Now you've done it", "Again?", "Still"]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
