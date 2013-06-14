class Show < Loco::Model
  adapter 'Loco::FixtureAdapter'
  property :title, :string
  has_many :episodes
end