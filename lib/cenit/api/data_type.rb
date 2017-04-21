module Cenit
  module API
    class DataType

      include UrlSlug
      include HttpReadable
      include HttpCreatable

      include Origin::Queryable
      include Enumerable

      def initialize(slug, parent = nil)
        @slug = slug
        @parent = parent
        super()
      end

      def default_headers
        Hash[super].deep_merge('X-Query-Selector' => process_hash(selector).to_json,
                               'X-Query-Options' => options.to_json)
      end

      def count
        if (response = get).code == 200
          response['count']
        else
          nil
        end
      end

      def each
        if block_given?
          page = 1
          while page
            if (response = get(query: { page: page, limit: 0 })).code == 200
              (response.values.detect { |v| v.is_a?(Array) } || []).each do |item|
                yield(item)
              end
              page =
                if response['total_pages'] > page
                  page + 1
                else
                  nil
                end
            else
              fail Error, "Unsuccessful response code: #{response.code}"
            end
          end
        end
      end

      def process_hash(hash)
        h = {}
        hash.each do |key, value|
          h[key] =
            case value
            when Regexp
              { '$regex': value.to_s }
            when Hash
              process_hash(value)
            else
              value
            end
        end
        h
      end

      protected :process_hash
    end
  end
end
