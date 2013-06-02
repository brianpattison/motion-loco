class Comment < Loco::Model
  adapter 'Loco::RESTAdapter'
  property :post_id
  property :body
end
