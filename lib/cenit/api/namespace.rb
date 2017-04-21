module Cenit
  module API
    class Namespace

      include UrlSlug
      include HttpDataRequester

      def push(data, options = {})
        options[:url] = "#{url}/push"
        do_data_request(:post, data, options)
      end

      def method_missing(symbol, *args)
        if args.length < 2
          dt = DataType.new(symbol, self)
          if args.length == 1
            Record.new(args[0], dt)
          else
            dt
          end
        else
          super
        end
      end
    end
  end
end
