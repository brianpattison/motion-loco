# Motion-Loco

[![Code Climate](https://codeclimate.com/github/brianpattison/motion-loco.png)](https://codeclimate.com/github/brianpattison/motion-loco)
[![Build Status](https://travis-ci.org/brianpattison/motion-loco.png?branch=new_hotness)](https://travis-ci.org/brianpattison/motion-loco)
[![Dependency Status](https://gemnasium.com/brianpattison/motion-loco.png)](https://gemnasium.com/brianpattison/motion-loco)

Motion-Loco is a library for [RubyMotion](http://rubymotion.com) 
that includes [Ember.js](http://emberjs.com) inspired bindings, 
computed properties, and observers.

## Installation

Add this line to your application's Gemfile:

    gem "motion-loco"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-loco

## Soon...

Complete rewrite is coming soon. You can watch 
the progress in this branch if you're bored. 

Here's a peak at the direction 
I'm hoping to go for version 0.4.0:

```ruby
class User < Loco::Model
  # Properties with types and defaults
  property :first_name, :string
  property :last_name, :string
  property :login_count, :integer, default: 0
  
  # Computed properties
  property :full_name, -> {|user|
    "#{user.get(:first_name)} #{user.get(:last_name)}"
  }.property(:first_name, :last_name)
  
  # Associations
  belongs_to :group
  has_many :posts, class_name: BlogPost
  
  # Computed properties will be able to 
  # observe a chain of properties
  property :post_count, -> {|user|
    user.posts.length
  }.property("posts.length")
  
  # Computed properties based on changes made
  # to records inside a Loco::RecordArray
  property :published_posts, -> {|user|
    user.posts.select{|post|
      post.get(:is_published)
    }
  }.property("posts.@each.is_published")
end

# Everything will use #get and #set so that computed properties
# can be cached and calculated only when required
@user = User.new(first_name: "Brian")
@user.get(:first_name)  # "Brian"
@user.get(:login_count) # 0

# Underscore and camelized properties work the same
@user.set(:lastName, "Pattison") # "Pattison"

# Chained property getters/setters
@user.get('group.name') # "The Awesome Group"
@user.set('group.name', "The Humble Group")

# Properties won't be KVO compliant, but it will
# be easy to create observers for any observable object.
@user.observe(:login_count, -> {|user|
  new_count = user.get(:login_count)
  user.remove_observer(:login_count)
})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
