class Score < Loco::Model
  adapter 'Loco::SQLiteAdapter'
  property :rank
  property :user_id
  property :value
end