require 'sinatra/base'

class MyApp < Sinatra::Base
  set :sessions, true
  set :foo, 'bar'

  get '/' do
    'Hello world!'
  end

  post '/github' do
    RelaxCI::Triggers::Github.trigger(request.body)
  end
end

run MyApp
