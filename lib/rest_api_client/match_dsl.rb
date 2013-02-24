require 'uri_template'

module RestApiClient 
  module MatchDsl
    class Matcher
      include Inflector

      def initialize(connection)
        @connection = connection
        @scope = []
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

      def resource(name, options = {})
        name = name.to_s
        match scoped_name(name) => scoped_path(name)

        with_scope name, :singular do
          yield 
        end if block_given?
      end

      def resources(name, options = {})
        name = name.to_s
        match scoped_name(name) => scoped_path(name), scoped_name(singularize(name)) => scoped_path("#{name}/:id")

        with_scope name, :plural do
          yield 
        end if block_given?
      end

      def scoped_name(*name)
        (@scope.map { |d| singularize(d.first) } + name).join("_")
      end

      def scoped_path(*path)
        (@scope.map { |d| d.last == :plural ? "#{d.first}/:#{d.first}" : d.first} + path).join("/") 
      end

      def with_scope(name, type)
        @scope << [name, type]
        yield 
        @scope.pop
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

