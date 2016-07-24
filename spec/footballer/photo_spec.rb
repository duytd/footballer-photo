require "spec_helper"

describe Footballer::Photo do
  it "has a version number" do
    expect(Footballer::Photo::VERSION).not_to be nil
  end

  it "parse a correct photo if player found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_photo "Wayne", "Rooney"
    expect(result).to eq("//cdn.soccerwiki.org/images/player/1139.jpg")
  end
end
