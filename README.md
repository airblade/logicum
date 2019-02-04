# Logicum

A simple, consistent interface for executing a unit of business logic.


## Usage

In a nutshell:

```ruby
class DoSomething
  # Turn your object into an interactor.
  include Logicum::Interactor

  # Declare any values available on the result of call().
  # You must set these instance variables in your call() method.
  provides :foo, :bar

  # Encapsulate your logic in a call() method.
  #
  # The call() method will not raise an error if your logic raises an error.
  # Instead the result will be a failure and the error message will be available.
  #
  # Returns a result object which responds to :success?, :failure?, and :error.
  def call(params:)
    # do stuff

    # Set the variables to provide on the result.
    @foo = params[:foo] + 3
    @bar = 153
  end
end

# And you use it like this:

result = DoSomething.new.call params: {foo: 42}
result.success?  # true
result.foo       # 45
result.bar       # 153
```

If you don't need to pass arguments into your initializer, you can send `:call` to the class instead:

```ruby
result = DoSomething.call params: {foo: 42}
```

The result is successful unless an exception is raised.  You can also explicitly make the result a failure using the `fail!` method, which takes an optional string message.

```ruby
class DoSomething
  include Logicum::Interactor

  def call(foo:)
    fail! 'This went wrong'
  end
end

result = DoSomething.call 153
result.failure?  # true
resut.error      # 'This went wrong'
```

## Purpose

The motivation was to move all business logic out of Rails controllers.

Instead of this:

```ruby
class UsersController < ApplicationController

  def create
    @user = User.new user_params

    if @user.save
      redirect_to @user
    else
      render :edit
    end
  end

end
```

You can write this:

```ruby
class AddUser
  include Logicum::Interactor

  provides :user

  def call(params)
    @user = User.new params
    @user.save!
  end
end


class UsersController < ApplicationController

  def create
    result = AddUser.call user_params

    if result.success?
      redirect_to result.user
    else
      @user = result.user
      render :edit
    end
  end

end
```

This is more code, so why bother?

The controller no longer has any business logic in it.  It simply mediates between HTTP and your domain.  We have separated concerns, reduced coupling, and increased cohesion.

It's a consistent interface.

If you situate all your business operations in a directory, e.g. `app/interactors/` or `app/services/`, you can see at a glance everything your application does.

The more complicated your logic gets, the more appealing this approach is.  The example above is simple and therefore not especially compelling :)  However as your application grows and you add business logic – e.g. sending emails, updating analytics, triggering background jobs – you can do it without cluttering up your controllers with details they should not know about.


## Inspiration

Although the command object / service object pattern has been around for ages I have never felt it was worthwhile for my applications.  However recently these three libraries persuaded me otherwise.

- GoCardless's [Coach](https://github.com/gocardless/coach)
- CollectiveIdea's [Interactor](https://github.com/collectiveidea/interactor)
- Hanami's [Interactor](https://github.com/hanami/utils/blob/a74304af5bb69f6a561aad2718943388fac30782/lib/hanami/interactor.rb)

I wanted something even lighter weight, providing just enough structure for the benefits to materialise, so I wrote my own.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logicum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logicum


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
