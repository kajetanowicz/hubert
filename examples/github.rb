# Simple github client

require 'net/http'
require 'hubert'

module Github
  class User
    extend Hubert::DSL

    https!
    host 'api.github.com'
    path_prefix '/users'

    url '/:username',                 as: 'summary'
    url '/:username/followers',       as: 'followers'
    url '/:username/gists',           as: 'gists'
    url '/:username/gists/:gist_id',  as: 'gist'

   
    def initialize(username)
      @username = username
    end

    def summary
      get summary_url(username: @username)
    end

    def followers
      get followers_url(username: @username)
    end

    def gists
      get gists_url(username: @username)
    end

    def gist(id)
      get gist_url(username: @username, gist_id: id)
    end

    private

    def get(uri)
      Net::HTTP.get URI(uri)
    end
  end
end
