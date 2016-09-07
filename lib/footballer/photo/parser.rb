require "nokogiri"
require "i18n"
require "restclient"

module Footballer
  module Photo
    class Parser
      PLAYER_PATH = File.join File.dirname(__FILE__), "data", "playerbasicdata.xml"
      CLUB_PATH = File.join File.dirname(__FILE__), "data", "clubdata.xml"
      MAPPING = [
        "áàâäéèêëíìîïóòôöúùûüýÿøčçćšşñž",
        "aaaaeeeeiiiioooouuuuyyocccssnz"
      ]

      def parse_player_photo first_name, last_name, partial=false
        data = File.open(PLAYER_PATH) { |f| Nokogiri::XML(f) }

        player = nil

        if first_name && last_name
          name =  "#{first_name} #{last_name}"
          f_matcher = "contains(\"#{translate_latin_character(name).capitalize}\", translate(@f, '#{MAPPING[0].upcase}#{MAPPING[0]}','#{MAPPING[1].upcase}#{MAPPING[1]}'))"
          s_matcher = "contains(\"#{translate_latin_character(name).upcase}\", translate(@s, '#{MAPPING[0].upcase}#{MAPPING[0]}','#{MAPPING[1].upcase}#{MAPPING[1]}'))"

          player = data.xpath("//P[#{f_matcher} and #{s_matcher}]").first
        end

        unless player.nil?
          player_image_base_url data, player.attr("i")
        else
          nil
        end
      end

      def parse_club_logo name
        puts "Getting #{name} logo"
        data = File.open(CLUB_PATH) { |f| Nokogiri::XML(f) }

        club = nil

        if name
          normalized_name = normalize_name name

          n_matcher = "contains(translate(@n, '#{MAPPING[0]}','#{MAPPING[1]}'), \"#{translate_latin_character(normalized_name)}\")"
          club = data.xpath("//C[#{n_matcher}]").first
        end

        unless club.nil?
          get_online_club_logo club.attr('id'), club_image_base_url(data)
        else
          nil
        end
      end

      private
      def get_online_club_logo id, base_url
        url = "https://en.soccerwiki.org/squad.php?clubid=#{id}"
        html = Nokogiri::HTML RestClient.get(url)
        logo = html.xpath "//img[contains(@src, '#{base_url}')]"
        logo.attr("src").value
      end

      def player_image_base_url xml, uri
        xml.xpath("//PlayerData")[0].attr("baseImageUrl").to_s + uri.to_s
      end

      def club_image_base_url xml
        xml.xpath("//ClubData")[0].attr("baseImageUrl").to_s
      end

      def normalize_name name
        name = name.split.map do |word|
          if word.length > 2 #Avoid words like FC, AC, FF
            word.split('-').map(&:capitalize).join('-')
          else
            word
          end
        end.join(' ')

        name.gsub! "Utd", "United"
        name
      end

      def translate_latin_character word
        I18n.available_locales = [:en]
        word = I18n.transliterate word
      end
    end
  end
end
