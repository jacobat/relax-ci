require 'json'
require 'sinatra/base'
require 'relax-ci'

class MyApp < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  post '/github' do
    if request.env["HTTP_X_GITHUB_EVENT"] == 'push'
      RelaxCI::Triggers::Github.trigger(JSON.parse(request.body.read))
    end
    nil
  end
end

run MyApp
