module MQTTVisualizer
  class WebsocketHandler
    KEEPALIVE_TIME = 15.freeze

    def initialize(app)
      @app = app
      @@clients = []
    end

    def self.parse_event_data(data)
      return data
    end

    def self.broadcast(msg)
       @@clients.each do |client|
         client.send(msg.to_json)
       end
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)

        ws.on(:open) do |event|
          p [:open, ws.object_id]
          @@clients << ws
          ws.send({ you: ws.object_id }.to_json)
          @@clients.each do |client|
            client.send({ count: @@clients.size }.to_json)
          end
        end

        ws.on(:message) do |event|
          p [:message, event.data]
          data = JSON.parse(event.data)
          user = data['user']
          action_name = data['action_name']
          action = MQTTVisualizer.config.key(action_name)
          unless CurrentMember.where(:user => user).empty?
            @@clients.each{ |wss| wss.send({ id: user, action_name: action_name }.to_json) }
            StatusLog.create(:user => user, :action => action)
            CurrentMember.find_by_user(user).update(status: action)
            MQTTVisualizer.post_update({:user => user, :action => action})
            MQTTVisualizer.log_sojourn_time(user, action) # if action == :out
          end
        end

        ws.on(:close) do |event|
          p [:close, ws.object_id, event.code]
          @@clients.delete(ws)
          @@clients.each do |client|
            client.send({ count: @@clients.size }.to_json)
          end
          ws = nil
        end
        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
