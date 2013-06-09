class Show < Loco::Model
  adapter 'Loco::FixtureAdapter'
  property :title, :string
end