require 'cenit/api/version'

require 'cenit/api/hash'
require 'httparty'
require 'origin'

require 'cenit/api/url_slug'
require 'cenit/api/http_query'
require 'cenit/api/http_requester'
require 'cenit/api/http_data_requester'
require 'cenit/api/http_creatable'
require 'cenit/api/http_updateable'
require 'cenit/api/http_readable'
require 'cenit/api/http_destroyable'

require 'cenit/api/record'
require 'cenit/api/data_type'
require 'cenit/api/namespace'
require 'cenit/api/error'

require 'cenit/config'

module Cenit

  module API

    class Version

      ALL = %w(v1 v2).collect(&:to_sym).freeze

      DEPRECATED = %w(v1).collect(&:to_sym).freeze

      include Cenit::API::UrlSlug

      def method_missing(symbol, *args)
        (args.length == 0 && Namespace.new(symbol, self)) || super
      end
    end

    class << self

      def method_missing(symbol, *args)
        (args.length == 0 && version(symbol)) || super
      end

      def const_missing(symbol)
        symbol = symbol.to_s.downcase.to_sym
        version(symbol) || super
      end

      def version(name)
        name = name.to_s.to_sym
        if Version::ALL.include?(name)
          if Version::DEPRECATED.include?(name)
            fail Error, "Deprecated version: #{name}"
          else
            Version.new(name, self)
          end
        end
      end

      def url
        "#{Cenit.host}/api"
      end
    end
  end
end
