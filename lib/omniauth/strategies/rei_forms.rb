require "omniauth/strategies/rei_forms"

# Potential scopes: 
# ------
# openid
#
# Separate scopes with a space (%20)

module OmniAuth
  module Strategies
    class REIForms < OmniAuth::Strategies::OAuth2
      STAGING_URL = 'https://accounts.staging.reiformslive.com.au'.freeze
      PRODUCTION_URL = 'https://accounts.reiformslive.com.au'.freeze
      
      option :name, 'rei_forms'

      option :client_options,
             authorize_url: '/oauth/authorize'

      # Overrride client to merge in site based on sandbox option
      def client
        ::OAuth2::Client.new(
          options.client_id,
          options.client_secret,
          deep_symbolize(options.client_options).merge(site: site)
        )
      end

      def request_phase
        request_params = {
          redirect_uri: callback_url,
        }.merge(authorize_params)

        redirect client.implicit.authorize_url(request_params)
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      # REI Forms send back the token in the hash fragments, rather than query
      # so we cant actually get our state or token...
      #
      # http://localhost:3000/v1/oauth/callback/rei_forms#env=staging&api=nsw&access_token=5b9555c2-cab8-438b-9678-b4dcad69cd28&state=5e04c70a91343eee146dfcb0a4dd64241ab4e5cb34d49ac2&token_type=Basic

      # def callback_phase
      #   self.access_token = ::OAuth2::AccessToken.from_kvform(client, query_string)
      #   super
      # end

      private

        def site
          options.staging ? STAGING_URL : PRODUCTION_URL
        end

    end
  end
end

OmniAuth.config.add_camelization 'rei_forms', 'REIForms'
