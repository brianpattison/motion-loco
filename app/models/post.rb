class Post < Loco::Model
  adapter 'Loco::RESTAdapter'
  property :title
  property :body
end
