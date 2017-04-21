module Cenit
  module API
    module HttpReadable

      include HttpRequester

      def get(options = {}, &block)
        do_request(:get, options, &block)
      end

    end
  end
end
