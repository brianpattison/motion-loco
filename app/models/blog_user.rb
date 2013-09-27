class BlogUser < Loco::Model
  has_many :posts, foreign_key: :author_id
  
  property :first_name, :string
  property :last_name, :string
end
