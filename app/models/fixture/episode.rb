class Episode < Loco::Model
  adapter 'Loco::FixtureAdapter'
  property :episode_number, :integer
  property :title, :string
  belongs_to :show
end
