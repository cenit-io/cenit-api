
require 'hashie/extensions/deep_merge'

module Cenit
  module API
    class Hash < ::Hash
      include Hashie::Extensions::DeepMerge
    end
  end
end