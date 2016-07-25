require "nokogiri"

module Footballer
  module Photo
    class Parser
      PATH = File.join File.dirname(__FILE__), "data", "playerbasicdata.xml"

      def initialize
        @data = File.open(PATH) { |f| Nokogiri::XML(f) }
      end

      def parse_photo first_name, last_name, partial=false
        player = nil

        if first_name && last_name
          if partial
            f_matcher = "contains(@f ,\"#{first_name.downcase.capitalize}\")"
            s_matcher = "contains(@s ,\"#{last_name.upcase}\")"
          else
            f_matcher = "@f=\"#{first_name.downcase.capitalize}\""
            s_matcher = "@s=\"#{last_name.upcase}\""
          end

          player = @data.xpath("//P[#{f_matcher} and #{s_matcher}]").first
        end

        unless player.nil?
          image_url player.attr("i")
        else
          nil
        end
      end

      private
      def image_url uri
        @data.xpath("//PlayerData")[0].attr("baseImageUrl").to_s + uri.to_s
      end
    end
  end
end
