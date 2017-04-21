module Cenit
  module API
    module HttpDataRequester

      include HttpRequester

      def do_request(method, options = {})
        options[:body] =
          case (body = options[:body])
          when Array, ::Hash
            body.to_json
          else
            body.to_s
          end
        super
      end

      def do_data_request(method, data, options = {}, &block)
        options[:body] = data
        do_request(method, options, &block)
      end
    end
  end
end
