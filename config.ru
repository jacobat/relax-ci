require 'json'
require 'pathname'
require 'sinatra/base'
require 'relax-ci'

bus = RelaxCI::Bus.new
bus.add_observer(RelaxCI::InitializeRepos.new(bus, Pathname.new('./repositories')))

class MyApp < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  post '/github' do
    if request.env["HTTP_X_GITHUB_EVENT"] == 'push'
      RelaxCI::Triggers::Github.new(settings.bus).trigger(JSON.parse(request.body.read))
    end
    nil
  end
end

MyApp.set :bus, bus
run MyApp
