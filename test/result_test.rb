require 'test_helper'
require 'logicum/result'

class ResultTest < Minitest::Test

  def setup
    @result = Logicum::Interactor::Result.new
  end


  def test_success_by_default
    assert @result.success?
    refute @result.failure?
  end


  def test_fail
    @result.fail!

    refute @result.success?
    assert @result.failure?
  end


  def test_fail_with_message
    @result.fail! 'foo'

    assert_equal 'foo', @result.error
  end
end
