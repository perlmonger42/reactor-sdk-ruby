require "test_helper"

class Adobe::ReactorTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Adobe::Reactor::VERSION
  end
end
