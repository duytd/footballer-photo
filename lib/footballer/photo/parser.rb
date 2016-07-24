require "nokogiri"

module Footballer
  module Photo
    class Parser
      PATH = File.join File.dirname(__FILE__), "data", "playerbasicdata.xml"

      def initialize
        @data = File.open(PATH) { |f| Nokogiri::XML(f) }
      end

      def parse_photo first_name, last_name
        player = @data.xpath("//P[@f='#{first_name.downcase.capitalize}' and @s='#{last_name.upcase}']").first

        unless player.nil?
          image_url player.attr("i")
        else
          nil
        end
      end

      private
      def image_url uri
        @data.xpath("//PlayerData")[0].attr("baseImageUrl") + uri
      end
    end
  end
end
