#!/usr/bin/ruby
# ---------------------
# Web interface which configures ethernet interfaces
# ---------------------

require 'sinatra'
load "get_op_status.rb"      # read operationnal status by CLI
load "set_itf_status.rb"      # read operationnal status by CLI


# get arguments (port number only)
port_nb = ARGV.shift || 8080 

# confiugure sinatra
set :server, 'thin'
set :port, port_nb
set :bind, '0.0.0.0'

configure do
   set :root, '.'
   set :views, 'views'
   # register html templates beginning vith .html.erb
   Tilt.register Tilt::ERBTemplate, 'html.erb'
end

# config: add specific interfaces into array
NICs = [  ] + get_network_interfaces()

# URL routage
get '/' do
  op_datas = get_op_data( NICs )
  erb :"index", :locals => { 'op_datas' => op_datas }
  # p op_datas
end

get '/configure' do
   op_datas = get_op_data( NICs )
   itf = params[:itf]
   erb :configure, :locals => { 'itf' => itf, 'data' => op_datas[itf] }
end

post '/configure' do
   tc_out = set_itf_status params[:itf], params
   erb :after_post, :locals => { 'tc_out' => tc_out }
   # quick hack: return "<pre> #{tc_out} </pre>"
end


