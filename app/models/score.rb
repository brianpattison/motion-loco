class Score < Loco::Model
  adapter 'Loco::SQLiteAdapter'
  property :rank, :integer
  property :user_id, :integer
  property :value, :string
end