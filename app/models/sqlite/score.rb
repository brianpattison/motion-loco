class Score < Loco::Model
  adapter 'Loco::SQLiteAdapter'
  property :rank, :integer
  property :value, :string
  belongs_to :player
end