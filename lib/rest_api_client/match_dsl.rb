require 'uri_template'

module RestApiClient 
  module MatchDsl
    class Matcher
      def initialize(connection)
        @connection = connection
      end

      def match(data = {})
        data.each do |k, v|
          define_singleton_method k do |*args|
            template = URITemplate.new(:colon, v)

            if args.first.is_a?(Hash)
              vars = args.first
            else
              vars = Hash[*template.variables.zip(args).flatten]
            end

            Resource.new(@connection, template.expand(vars))
          end
        end
      end

    end

    class Resource
      attr_reader :url

      def initialize(connection, url)
        @connection = connection
        @url = url
      end

    end
  end
end

