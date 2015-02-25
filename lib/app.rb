%w(
  addressable/uri
  faye/websocket
  haml
  influxdb
  ipaddress
  json
  open-uri
  mqtt
  puma
  sass/plugin/rack
  sinatra/activerecord
  sinatra/base
  time
  yaml
).each { |lib| require lib }

%w(
  active_node
  core
  subscriber
  websocket_handler
  influxdb_client
).each { |name| require_dependency File.expand_path("../gif-iot/#{name}", __FILE__) }

module GIFIoT
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :database, GIFIoT.config[:database]
    set :root, File.expand_path("../../", __FILE__)

    get '/' do
      @title = GIFIoT.config[:title]
      @nodes = []
      ActiveNode.all.each do |m|
        @nodes << m
      end
      haml :index
    end

    get '/graph/:id' do
      @id = "#{params[:id]}"
      @title = GIFIoT.config[:title] + " Graph: " + @id
      haml :graph
    end

    get '/ip/openblocks/:id' do
      begin
        ip = ActiveNode.find(params[:id]).ip
      rescue ActiveRecord::RecordNotFound
        ip = '?'
      end
      ip
    end

    get '/xml/:name' do
      InfluxdbClient.query_to_xml(params[:name])
    end
  end
end

