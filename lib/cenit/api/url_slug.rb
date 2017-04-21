module Cenit
  module API
    module UrlSlug

      attr_reader :parent, :slug

      def initialize(slug, parent = nil)
        @slug = slug
        @parent = parent
      end

      def url
        url = parent ? parent.url : ''
        "#{url}/#{slug}"
      end

    end
  end
end
