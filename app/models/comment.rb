class Comment < Loco::Model
  adapter 'Loco::RESTAdapter', 'http://localhost:3000'
  property :post_id
  property :body
end
