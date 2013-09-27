class Post < Loco::Model
  belongs_to :author, class_name: BlogUser
  has_many :comments
  
  property :title, :string
  property :body, :string
end
