require "nokogiri"

module Footballer
  module Photo
    class Parser
      PLAYER_PATH = File.join File.dirname(__FILE__), "data", "playerbasicdata.xml"
      CLUB_PATH = File.join File.dirname(__FILE__), "data", "clubdata.xml"

      def parse_player_photo first_name, last_name, partial=false
        data = File.open(PLAYER_PATH) { |f| Nokogiri::XML(f) }

        player = nil

        if first_name && last_name
          f_matcher = "@f=\"#{first_name.downcase.capitalize}\""
          s_matcher = "@s=\"#{last_name.upcase}\""

          player = data.xpath("//P[#{f_matcher} and #{s_matcher}]").first
        end

        unless player.nil?
          player_image_base_url data, player.attr("i")
        else
          nil
        end
      end

      def parse_club_logo name
        data = File.open(CLUB_PATH) { |f| Nokogiri::XML(f) }

        club = nil

        if name
          n_matcher = "contains(@n ,\"#{name.split.map(&:capitalize).join(' ')}\")"
          club = data.xpath("//C[#{n_matcher}]").first
        end

        unless club.nil?
          club_image_base_url data, "#{club.attr('id')}.jpg"
        else
          nil
        end
      end

      private
      def player_image_base_url xml, uri
        xml.xpath("//PlayerData")[0].attr("baseImageUrl").to_s + uri.to_s
      end

      def club_image_base_url xml, uri
        xml.xpath("//ClubData")[0].attr("baseImageUrl").to_s + uri.to_s
      end
    end
  end
end
