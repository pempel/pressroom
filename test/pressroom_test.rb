require "test_helper"

class PressroomTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pressroom::VERSION
  end
end
