# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

post1 = Post.create(title: "My first blog post", body: "Check out RubyMotion!")
Comment.create(body: "I love Ruby and iOS!", post_id: post1.id)
Comment.create(body: "Just use Objective-C!", post_id: post1.id)
Comment.create(body: "Nah Objective-C is ugly.", post_id: post1.id)

post2 = Post.create(title: "And for my next post...", body: "Like RubyMotion and Ember.js? Check out Motion-Loco on GitHub.")
Comment.create(body: "Yay! A REST data adapter!", post_id: post2.id)
Comment.create(body: "What's a Rails app doing in a RubyMotion gem repo??", post_id: post2.id)
Comment.create(body: "I do what I want!", post_id: post2.id)