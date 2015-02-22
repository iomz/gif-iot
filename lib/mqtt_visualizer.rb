%w(
  addressable/uri
  faye/websocket
  haml
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
).each { |name| require_dependency File.expand_path("../mqtt_visualizer/#{name}", __FILE__) }

module MQTTVisualizer
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :database, MQTTVisualizer.config[:database]
    set :root, File.expand_path("../../", __FILE__)

    get '/' do
      @title = MQTTVisualizer.config[:title]
      @nodes = []
      ActiveNode.all.each do |m|
        @nodes << m
      end
      haml :index
    end

    get '/graph/:id' do
      @title = MQTTVisualizer.config[:title] + " Graph: " +:id.to_s
      haml :graph
    end

  end
end

