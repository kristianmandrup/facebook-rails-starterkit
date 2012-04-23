## Facebook Rails starter kit

This gem leverages the gem: 'joey'. Joey in turn sits on top of 'koala' and uses the 'hashie' gem for easy hash access (as returned by the Facebook graph API via Koala).

In an initializer or similar "boot location" for your app facebook integration:

```ruby
Facebook.app = MyCool::FacebookAppConfig.instance
```

You can then define an app class that implements the following API. 

Note: You may wan to load these values from a yaml file, and have the yaml filename as part of your `.gitignore`. You might want to look at 'facebooker2' gem for inspiration here (fx to support multiple environments). You have to have (or create) a Facebook App that is linked to your Rails application.

```ruby
class MyCool
	class FacebookAppConfig
		include Singleton

		# please change!
		def id
			'219868431409649' 
		end

		# please change!
		def secret
			'7e5699f155df01d8e52b35c01dccd627' 
		end

		# please change for staging/production
		def url
			'http://localhost:3000'
		end

		# please customize (see Facebook permissions)
		# https://developers.facebook.com/docs/authentication/permissions/
		def default_permissions
	    ["publish_stream", "read_stream", "email"]
	  end
	end
end
```

The `facebook.yml` file in `config/apis`:

```yaml
id: 219868431409649
secret: 7e5699f155df01d8e52b35c01dccd627
url: http://localhost:3000
default_permissions: ["publish_stream", "read_stream", "email"]
```

And here how to load it into the AppConfig singleton.

```ruby
class MyCool
	class FacebookAppConfig
		include Singleton

		def loader
			@loader ||= ConfigLoader::Yaml.new 'apis', 'facebook.yml'
		end

		def secret
			loader.load.secret
		end
	end
end
```

Or using the special Delegator module included. This module requires a #config method to be defined like so:

```ruby
class MyCool
	class FacebookAppConfig
		include Singleton
		include ConfigLoader::Delegator

		def config
			@config ||= ConfigLoader::Yaml.new 'apis', 'facebook.yml'
		end
	end
end
```

Here a call to any method not defined on this app config, will be delegated to the loader, which returns the yaml as a Hashie for direct method access.
This would allow you to:

`Facebook.app.secret` # => value loaded from 'secret' entry in facebook.yml

## Facebook access controllers

The module `Facebook::Access::Helper` can be included in controllers that require Facebook access (via signin).

```ruby
class CampaignController < ApplicationController
	include Facebook::Access::Helper

  def signup
  	fb_login
  end
end
```

Some of the key methods made available are:

* fb_retrieve_access_token
* fb_login(permissions)
* fb_app
* fb_graph
* signed_request
* registration

You can now access the Facebook graph API for the current (session) user.

For this to work, it requires a previous Facebook login which can be done fx via the Facebook login button (see fx 'facebook-social_plugins' gem). Alternatively use OAuth directly.

## Facebook Graph API

The `fb_graph` method returns a class with some nice convenience methods. The 
graph api used is `Koala::Facebook::GraphAndRestAPI` from the `joey` gem, which uses Hashie (see `hashie gem) under the covers for easy access into the hashes returned.

* me

The following methods are all prefixed with 'my_'

* name
* first_name
* last_name
* username
* email
* picture
* friends
* messages

Examples: `my_name` and `my_first_name` and so on.

```ruby
fb_graph.my_username
```

Currently only the following post API is provided

* post_on_wall(message)

## Facebook (and alternative OmniAuth) Authentication via Devise

This module is designed to help you quickly get started with Facebook - Devise integration and possibly other OAuth providers. Please see Railscasts [omniauth-part-1](http://railscasts.com/episodes/235-omniauth-part-1) and [omniauth-part-2](http://railscasts.com/episodes/236-omniauth-part-2)

In your ApplicationController or some other class/module included in your `AuthenticationsController` you
can override the `new_user` method if you need to. 

```ruby
	# override as needed
	def new_user
		User.new
	end
```

Then simply include the `Facebook::Auth::Devise` module in your controller.

```ruby
class AuthenticationsController < InheritedResources::Base
	include Facebook::Auth::Devise

	def new_user
		Profile.new
	end
end
```

This module adds controller REST methods for:

* index
* create
* destroy

The following translation keys must be defined in a locale file (or similar i18n translation):

* facebook.auth.signed_in
* facebook.auth.success
* facebook.auth.destroyed

You can easily customize this module to suit your app by overriding any of the following methods:

* user_authentication_destroyed
* current_user_authentication
* authenticated
* authenticate_user
* authenticate_new_user
* authenticated_user_saved
* authenticated_user_not_saved
* authentication

## Mode configuration

```ruby
# in your User class
class Profile
  has_many :authentications
```

In your console:

```
rails g model authentication uid:string provider:string user_id:integer
```

Model:

```ruby
class Authentication < ActiveRecord::Base
  attr_accessible :create, :destroy, :index, :provider, :uid, :user_id

	belongs_to :user  
end
```

Migration:

```ruby
class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string  :provider
      t.string  :uid # the unique userid of the User supplied by the provider
      t.string  :index
      t.string  :create
      t.string  :destroy

      t.timestamps
    end
  end
end
```

```
rake db:migrate
```


## Facebook Route setup

In your `routes.rb file

```ruby
match 'facebook/registration' => 'registrations#create', :as => :new_user_registration

# See http://railscasts.com/episodes/235-omniauth-part-1
match 'auth/:provider/callback' => 'authentications#create'
```

## Contributing to facebook-rails-starterkit
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Kristian Mandrup. See LICENSE.txt for
further details.

