require 'test_helper'
require 'logicum/errors'

class ErrorsTest < Minitest::Test

  def test_defined
    assert_operator Logicum::ProvisionError,   :<, Logicum::Error
    assert_operator Logicum::MissingCallError, :<, Logicum::Error
  end

end
