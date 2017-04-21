module Cenit
  module API
    module HttpRequester

      include HttpQuery

      def do_request(method, options = {})
        options = Hash[{ headers: default_headers, query: query }].deep_merge(options)
        response = HTTParty.send(method, options[:url] || url, options)
        if block_given?
          yield response
        else
          response
        end
      end

      def default_headers
        headers = { 'Content-Type' => 'application/json' }
        if (token = Cenit.access_token) && (key = Cenit.access_key)
          headers['X-User-Access-Key'] = key
          headers['X-User-Access-Token'] = token
        end
        headers
      end

      protected :do_request, :default_headers

    end
  end
end
