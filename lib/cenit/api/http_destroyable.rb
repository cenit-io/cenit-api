module Cenit
  module API
    module HttpDestroyable

      include HttpRequester

      def delete(options = {}, &block)
        do_request(:delete, options, &block)
      end

      def destroy(options = {}, &block)
        delete(options, &block)
      end

    end
  end
end
