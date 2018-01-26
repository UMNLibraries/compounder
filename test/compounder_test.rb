require 'test_helper'

module Compounder
  class CompounderTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Compounder::VERSION
    end
  end
end