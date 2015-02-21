%w(
  addressable/uri
  faye/websocket
  haml
  json
  open-uri
  mqtt
  puma
  sinatra/activerecord
  sinatra/base
  time
  yaml
).each { |lib| require lib }

%w(
  active_node
  core
  websocket_handler
).each { |name| require_dependency File.expand_path("../mqtt-visualizer/#{name}", __FILE__) }

module MQTTVisualizer
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :database, MQTTVisualizer.config[:database]
    set :root, File.expand_path("../../", __FILE__)

    get '/' do
      @title = MQTTVisualizer.config[:title]
      @nodes = []
      ActiveNode.all.each do |m|
        @node << m
      end
      haml :index
    end
  end
end

