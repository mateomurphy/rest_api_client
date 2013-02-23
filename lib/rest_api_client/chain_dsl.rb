module RestApiClient
  module ChainDsl
    class Resource

      def initialize(connection, url_parts = [])
        @connection = connection
        @url_parts = url_parts
      end

      def method_missing(name, *args, &block)
        name = name.to_s
        if name[-1] == '!'
          request!(name[0..-2], *args, &block)
        else
          url_parts = @url_parts + [name]
          url_parts << args[0].to_s if args[0]
          self.class.new(@connection, url_parts)
        end
      end

      def request!(method, *args, &block)
        @connection.send(method, url!, *args, &block)
      end

      def url!
        File.join(@url_parts)
      end

    end

  end
end