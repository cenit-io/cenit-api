
module Cenit
  module API
    class Record

      include UrlSlug
      include HttpReadable
      include HttpUpdateable
      include HttpDestroyable

      def id
        slug
      end

      def id=(id)
        self.slug = id
      end
    end
  end
end
