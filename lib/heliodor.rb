require 'bson'
require 'zlib'

module Heliodor
end

require 'heliodor/version'
require 'heliodor/db'
require 'heliodor/query'
require 'heliodor/query_internal'

class Hash
  def add_key(key)
    self[key] = nil
    self
  end
end
