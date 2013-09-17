# Motion-Loco

Motion-Loco is a library for [RubyMotion](http://rubymotion.com) 
that includes [Ember.js](http://emberjs.com) inspired bindings, 
computed properties, and observers. **And Ember-Data inspired [data](#locofixtureadapter) [adapters](#locorestadapter)!**

## What's New!

### June 23th, 2013

#### SQLiteAdapter and Relationships!

I need to write up some better documentation, but be sure to check out the [Loco::SQLiteAdapter](#locosqliteadapter) and the new `has_many` and `belongs_to` relationships in `Loco::Model`.

The relationship stuff needs some major code clean up, so don't copy my code if you're doing anything similar for loading/saving relationship data. :)

The [tests](https://github.com/brianpattison/motion-loco/tree/master/spec) all pass though... so that's something, right?

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
  property :first_name, :string
  property :last_name, :string
  
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
  property :first_name, :string
  property :last_name, :string
  property :full_name, lambda{|object|
    "#{object.first_name} #{object.last_name}"
  }.property(:first_name, :last_name)
end

@person = Person.new(
  first_name: 'Brian',
  last_name:  'Pattison'
)

@label = Loco::UI::Label.alloc.initWithFrame(
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

@label = Loco::UI::Label.alloc.initWithFrame(
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

### Loco::UI::TableView

A `Loco::UI::TableView` is used for to easily bind a collection of objects
to a `UITableView` and each item in the collection to a reusable `UITableViewCell`.

```ruby
class MyTableViewCell < Loco::UI::TableViewCell
  # The `view_setup` method is called the first time the cell is created.
  # Bindings can be made to the item assigned to the cell
  # by binding to `parentView.content`.
  def view_setup
    @label = Loco::UI::Label.alloc.initWithFrame(
      textBinding: 'parentView.content.first_name',
      height: 30,
      left: 60,
      right: 30,
      top: 5
    )
    self.addSubview(@label)
  end
end

class MyTableView < Loco::UI::TableView
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
  property :title, :string
end

@show = Show.find(2) # Loads from `resources/fixtures/plural_class_name.json`
@show.title          # "Brian's Video Clip Show"
```

### Loco::RESTAdapter

```ruby
class Post < Loco::Model
  adapter 'Loco::RESTAdapter', 'http://localhost:3000'
  property :title, :string
  property :body, :string
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

# GET http://localhost:3000/posts.json
# {
#   "posts": [
#     {
#       "id": 1,
#       "title": "My first blog post",
#       "body": "Check out RubyMotion!"
#     },
#     {
#       "id": 2,
#       "title": "And for my next post...",
#       "body": "Like RubyMotion and Ember.js? Check out Motion-Loco on GitHub."
#     }
#   ]
# }
@posts = Post.all do |posts|
  posts.length # 2
end

# Started POST "/posts.json"
# Processing by PostsController#create as JSON
# Parameters: {"post"=>{"title"=>"Loco::RESTAdapter can save!", "body"=>"Hopefully."}}
@post = Post.new(title: 'Loco::RESTAdapter can save!', body: 'Hopefully.')
@post.save do |post|
  post.id # Yay! It has an ID now!
end
```

### Loco::SQLiteAdapter
```ruby
class Player < Loco::Model
  adapter 'Loco::SQLiteAdapter'
  property :name, :string
  has_many :scores
end

class Score < Loco::Model
  adapter 'Loco::SQLiteAdapter'
  property :rank, :integer
  property :value, :integer
  belongs_to :player
end

@player = Player.new(name: 'Kirsten Pattison')
@player.save

@score = Score.new(rank: 1, value: 50000, player: @player)
@score.save

@player.scores.length # 1
@score.player.name    # Kirsten Pattison
```

## TODO

- RESTAdapter
    - Sideload belongs_to/has_many
- SQLiteAdapter
    - Data migrations?
- State Manager
    - Pretty big challenge, so it might be a while
    - Limit transitions between states
    - Rollback dirty/unsaved records
- Improve everything! :)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
