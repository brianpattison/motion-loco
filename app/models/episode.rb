class Episode < Loco::Model
  adapter 'Loco::FixtureAdapter'
  property :show_id, :integer
  property :episode_number, :integer
  property :title, :string
end
