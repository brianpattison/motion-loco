# Motion-Loco

Motion-Loco is a library for [RubyMotion](http://rubymotion.com) 
that includes [Ember.js](http://emberjs.com) inspired bindings, 
computed properties, and observers.

Also included is a set of views that are easier to position and size.

**I'm not using this in production yet. It might be ready, 
but I feel like it needs some more features to really be useful.**

## What's New!

### June 7th, 2013

#### Data Adapters

These are still a bit of a work in progress, but [worth](#locofixtureadapter) [checking out](#locorestadapter)!

## Installation

Add this line to your application's Gemfile:

    gem 'motion-loco'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-loco

## Usage

### Computed Properties

Computed properties are properties that are computed from one or multiple properties.
They beat out using a method because they can be observed like any other property.

```ruby
class Person < Loco::Model
  property :first_name
  property :last_name
  
  # Computed property for full name that watches for changes
  # in the object's first_name and last_name properties.
  property :full_name, lambda{|object|
    "#{object.first_name} #{object.last_name}"
  }.property(:first_name, :last_name)
end

@person = Person.new(
  first_name: 'Brian',
  last_name:  'Pattison'
)

@person.full_name # "Brian Pattison"
```

### Bindings

Bindings are used to link the property of an object to a property of another object.

```ruby
class Person < Loco::Model
  property :first_name
  property :last_name
  property :full_name, lambda{|object|
    "#{object.first_name} #{object.last_name}"
  }.property(:first_name, :last_name)
end

@person = Person.new(
  first_name: 'Brian',
  last_name:  'Pattison'
)

@label = Loco::Label.alloc.initWithFrame(
  textBinding: [@person, 'full_name'],
  height: 30,
  top: 20,
  width: 200
)

@label.text # "Brian Pattison"
```

### Loco::Controller

A `Loco::Controller` is a singleton class that is especially useful for 
binding objects' properties to view properties.

```ruby
class PersonController < Loco::Controller
  property :content
end

@label = Loco::Label.alloc.initWithFrame(
  textBinding: 'PersonController.content.full_name',
  height: 30,
  top: 20,
  width: 200
)

@person = Person.new(
  first_name: 'Brian',
  last_name:  'Pattison'
)

PersonController.content = @person

@label.text # "Brian Pattison"
```

### Loco::TableView

A `Loco::TableView` is used for to easily bind a collection of objects
to a `UITableView` and each item in the collection to a reusable `UITableViewCell`.

```ruby
class MyTableViewCell < Loco::TableViewCell
  # The `view_setup` method is called the first time the cell is created.
  # Bindings can be made to the item assigned to the cell
  # by binding to `parentView.content`.
  def view_setup
    @label = Loco::Label.alloc.initWithFrame(
      textBinding: 'parentView.content.first_name',
      height: 30,
      left: 60,
      right: 30,
      top: 5
    )
    self.addSubview(@label)
  end
end

class MyTableView < Loco::TableView
  item_view_class MyTableViewCell
end

@table_view = MyTableView.alloc.initWithFrame(
  content: [Person.new(first_name: 'Brian'), Person.new(first_name: 'Kirsten')],
  bottom: 0,
  left: 0,
  right: 0,
  top: 0
)
```

### Loco::FixtureAdapter

```ruby
class Show < Loco::Model
  adapter 'Loco::FixtureAdapter'
  property :title
end

@show = Show.find(2) # Loads from `resources/fixtures/plural_class_name.json`
@show.title          # "Brian's Video Clip Show"
```

### Loco::RESTAdapter

```ruby
class Post < Loco::Model
  adapter 'Loco::RESTAdapter', 'http://localhost:3000'
  property :title
  property :body
end

# GET http://localhost:3000/posts/1.json
# {
#   "post": {
#     "id": 1,
#     "title": "My first blog post",
#     "body": "Check out RubyMotion!"
#   }
# }
@post = Post.find(1) do |post|
  post.id    # 1
  post.title # "My first blog post"
  post.body  # "Check out RubyMotion!"
end

@post = Post.new(title: 'New! The Loco::RESTAdapter', body: 'Yay! A REST data adapter!')
@post.save do |post|
  post.id # Yay! It has an ID now!
end
```

## Todo

- State Manager
- Relationships
- More Adapters
    - Core Data (Are SQLite and iCloud also part of this adapter??)
- Lots of stuff

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
