require 'json'
require 'pathname'
require 'sinatra/base'
require 'relax-ci'
require 'logger'

RELAX_ROOT = Pathname.new(__FILE__).parent
log_dir = RELAX_ROOT.join('log')
log_dir.mkdir unless log_dir.exist?
logger = Logger.new(log_dir.join('development.log'))
bus = RelaxCI::Bus.new(logger)
bus.add_observer(RelaxCI::InitializeRepos.new(bus, logger, RELAX_ROOT.join('repositories')))

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
