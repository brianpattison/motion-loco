class Player < Loco::Model
  adapter 'Loco::SQLiteAdapter'
  property :name, :string
  has_many :scores
end