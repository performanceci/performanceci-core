 require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
   wait_for = 1.01
   sleep(wait_for)
   'Hello world!'
end

get '/test' do
  wait_for = 0.1
  sleep(wait_for)
  'I was tired'
end
