require 'test_helper'

class InteractorTest < Minitest::Test

  def test_inclusion
    klass = Class.new do
      include Logicum::Interactor
    end

    assert_respond_to klass.new, :call
  end


  def test_missing_call
    klass = Class.new do
      include Logicum::Interactor
    end

    assert_raises Logicum::MissingCallError do
      klass.new.call
    end
  end


  def test_success
    klass = Class.new do
      include Logicum::Interactor

      def call
      end
    end

    result = klass.new.call
    assert result.success?
  end


  def test_explicit_failure
    klass = Class.new do
      include Logicum::Interactor

      def call
        fail!
      end
    end

    result = klass.new.call
    refute result.success?
  end


  def test_exception_causes_failure
    klass = Class.new do
      include Logicum::Interactor

      def call
        raise
      end
    end

    result = klass.new.call
    refute result.success?
  end


  def test_call_arguments
    klass = Class.new do
      include Logicum::Interactor

      def call(foo:)
      end
    end

    result = klass.new.call foo: 153
    assert result.success?
  end


  def test_call_shortcut
    klass = Class.new do
      include Logicum::Interactor

      def call(foo:)
      end
    end

    result = klass.call foo: 153
    assert result.success?
  end


  def test_provides
    klass = Class.new do
      include Logicum::Interactor

      provides :foo

      def call
        @foo = 153
      end
    end

    result = klass.new.call
    assert_equal 153, result.foo
  end


  def test_provides_ivar_not_set
    klass = Class.new do
      include Logicum::Interactor

      provides :foo

      def call
      end
    end

    exception = assert_raises Logicum::ProvisionError do
      klass.new.call
    end

    assert exception.message.include? '@foo'
  end


  def test_provides_despite_exception
    klass = Class.new do
      include Logicum::Interactor

      provides :foo

      def call
        @foo = 153
        raise
      end
    end

    result = klass.new.call
    assert_equal 153, result.foo
  end

end
