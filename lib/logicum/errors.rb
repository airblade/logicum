module Logicum

  Error = Class.new StandardError

  # The business object does not implement a call() instance method.
  MissingCallError = Class.new Error

  # The business object declares that it provides a value, but it was
  # not set in the call() instance method.
  ProvisionError = Class.new Error

end
