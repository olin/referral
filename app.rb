require 'sinatra'
require 'haml'
require 'json'

enable :sessions
set :haml, :format => :html5

# CONFIG START
# thing = ENV['thing']

if ENV['RACK_ENV'] == 'development'
else
end
# CONFIG END

get '/' do
	haml :index
end

