class Comment < Loco::Model
  property :body, :string
  belongs_to :post
end
