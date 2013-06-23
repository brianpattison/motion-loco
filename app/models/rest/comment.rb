class Comment < Loco::Model
  adapter 'Loco::RESTAdapter', 'http://localhost:3000'
  property :body, :string
  belongs_to :post
end
