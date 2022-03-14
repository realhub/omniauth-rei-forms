# Omniauth::REIForms

This is an unofficial OmniAuth strategy for authenticating with REI Forms Live. To get started, read the documentation at https://developer.reiformslive.com.au/docs/index.html

You will need to setup a REI Forms Live account. Contact the REI Forms Live team once you are ready.

IMPORTANT - This does not work yet as we require token to be sent as a query param, not a hash fragment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-rei-forms-live'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-rei-forms-live

## Usage with Rails & Devise

Add the following to `config/initializers/devise.rb`
```ruby
config.omniauth :rei_forms,
    ENV['REI_FORMS_LIVE_CLIENT_ID'],
    nil,
    :staging => ENV['REI_FORMS_LIVE_API_MODE'] != 'production',
    :scope => 'openid'
```

Add `:rei_forms` to the `:omniauth_providers` array for your devise model. e.g.

```ruby
class User < ApplicationRecord
  devise :omniauthable, :omniauth_providers => [:rei_forms]
end
```

You can then access the url using the helper `user_rei_forms_omniauth_authorize_path`

## Basic Usage

```ruby
use OmniAuth::Builder do
  provider :rei_forms, ENV['REI_FORMS_LIVE_CLIENT_ID'], nil, scope: 'openid'
end
```
