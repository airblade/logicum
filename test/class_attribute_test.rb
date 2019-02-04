require 'test_helper'
require 'logicum/class_attribute'

class ClassAttributeTest < Minitest::Test

  def setup
    @klass = Class.new do
      include Logicum::ClassAttribute
    end
  end


  def test_inclusion
    assert_respond_to @klass, :class_attribute
  end


  def test_accessor
    @klass.class_attribute :foo
    @klass.foo = 42

    assert_equal 42, @klass.foo
  end


  def test_subclass
    subclass = Class.new @klass

    @klass.class_attribute :foo
    @klass.foo = 42
    subclass.foo = 153

    assert_equal 42, @klass.foo
    assert_equal 153, subclass.foo
  end
end
