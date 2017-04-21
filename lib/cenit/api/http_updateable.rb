module Cenit
  module API
    module HttpUpdateable

      include HttpDataRequester

      def post(data, options = {}, &block)
        do_data_request(:post, data, options, &block)
      end

      def update(data, options = {}, &block)
        post(data, options, &block)
      end

    end
  end
end
