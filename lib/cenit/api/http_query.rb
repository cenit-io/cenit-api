module Cenit
  module API
    module HttpQuery

      def query
        @query ||= {}
      end

      def method_missing(symbol, *args)
        case args.length
        when 0
          super
        when 1
          query[symbol] = args[0]
          self
        else
          query[symbol] = args.collect(&:to_s).flatten.join(',')
          self
        end
      end
    end
  end
end
