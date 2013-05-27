class Episode < Loco::Model
  adapter 'Loco::FixtureAdapter'
  property :show_id
  property :episode_number
  property :title
end
