require 'rest_api_client/version'

require 'faraday'
require 'faraday_middleware'

require 'rest_api_client/chain_dsl'
require 'rest_api_client/match_dsl'

module RestApiClient
  def self.chain(url, options = {})
    ChainDsl::Resource.new(connection(:url => url))
  end

  def self.match(url, options = {})
    matcher = MatchDsl::Matcher.new(connection(:url => url))
    yield matcher
    matcher
  end

  def self.connection(options = {})
    @connection ||= ::Faraday.new(options) do |config|
      config.response :mashify
      config.response :xml,  :content_type => /\bxml$/
      config.response :json, :content_type => /\bjson$/
      config.response :follow_redirects

      config.adapter Faraday.default_adapter
    end
  end    
end
