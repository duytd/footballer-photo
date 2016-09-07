require "spec_helper"

describe Footballer::Photo do
  it "has a version number" do
    expect(Footballer::Photo::VERSION).not_to be nil
  end

  it "parse a correct photo using full name if player found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_player_photo "Lionel", "Messi"
    expect(result).to eq("//cdn.soccerwiki.org/images/player/2772.jpg")
  end

  it "return nil if no player found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_player_photo "Duy", "Trinh"
    expect(result).to eq(nil)
  end

  it "return a correct club logo if club name (in normal form) found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_club_logo "Manchester United"
    expect(result).to eq("//smimgs.com/images/logos/clubs/49.jpg")
  end

  it "return a correct club logo if club name (in lowercase) found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_club_logo "manchester united"
    expect(result).to eq("//smimgs.com/images/logos/clubs/49.jpg")
  end

  it "return a correct club logo if club name (in uppercase) found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_club_logo "MANCHESTER UNITED"
    expect(result).to eq("//smimgs.com/images/logos/clubs/49.jpg")
  end

  it "return a correct club logo if club name (with latin characters) found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_club_logo "Sochaux-Montbéliard"
    expect(result).to eq("//smimgs.com/images/logos/clubs/343.jpg")
  end

  it "return nil if no club found" do
    parser = Footballer::Photo::Parser.new
    result = parser.parse_club_logo "Duy Trinh"
    expect(result).to eq(nil)
  end
end
