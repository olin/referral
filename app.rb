require 'sinatra'
require 'haml'
require 'json'
require 'redis'

enable :sessions
set :haml, :format => :html5

# CONFIG START
# thing = ENV['thing']
if ENV['RACK_ENV'] == 'development'
	HOST = 'http://localhost:3000'
else
	HOST = 'http://referrrr.com'
end
# CONFIG END

redis = Redis.new

get '/' do
	if session[:id].nil?
		haml :welcome, :locals => { :id => nil, :referral_url => nil }
	else
		id = session[:id]
		haml :welcome, :locals => { :id => id, :referral_url => HOST + "/#{id}" }
	end
end

# just create a new user with no parent
get '/new' do
	if session[:id].nil?
		# no cookie, first time, so make a new user with parent :id
		if (redis.keys "users").nil?
			# no users at all, create a fresh one
			new_id = 1
		else
			# get largest user + 1
			new_id = (redis.scard "users").to_i + 1
		end

		parent_id = 0
		session[:id] = new_id

		redis.sadd "users", new_id
		redis.sadd "users:#{parent_id}:children", new_id
		redis.sadd "users:#{new_id}:parent", parent_id
		score = 1

		haml :index, :locals => {
			:score => score,
			:id => new_id,
			:parent_id => parent_id,
			:referral_url => HOST + "/#{new_id}"
		}
	else
		redirect "/"
	end
end

get '/:id' do

	if not redis.sismember "users", params[:id]
		# not a user
		haml :error, :locals => {:id => params[:id]}
	else
		if session[:id].nil?
			# no cookie, first time, so make a new user with parent :id
			new_id = (redis.scard "users").to_i + 1
			parent_id = params[:id]
			session[:id] = new_id

			redis.sadd "users", new_id
			redis.sadd "users:#{parent_id}:children", new_id
			redis.sadd "users:#{new_id}:parent", parent_id
			score = 1

			redis.incr "users:#{parent_id}:score"

			haml :index, :locals => {
				:score => score,
				:id => new_id,
				:parent_id => parent_id,
				:referral_url => HOST + "/#{new_id}"
			}
		else
			# cookie, so user is just viewing
			user_id = params[:id]
			my_id = session[:id]
			score = 1
			parent_id = redis.smembers "users:#{user_id}:parent"

			haml :show, :locals => {
				:score => score,
				:id => user_id,
				:my_id => my_id,
				:parent_id => parent_id,
				:referral_url => HOST + "/#{user_id}"
			}
		end
	end
end