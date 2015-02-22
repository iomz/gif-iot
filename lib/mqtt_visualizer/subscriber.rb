module MQTTVisualizer
  module Subscriber
    def start_subscribe()
      puts "* Starting to subscribe"
      t = Thread.new do
        MQTT::Client.connect(MQTTVisualizer.config[:host]) do |c|
          c.get('gif-iot/#') do |topic,message|
            topics = topic.split('/')
            case topics[1]
            when 'ip'
              data = JSON.parse(message)
              ip = data["ip"]
              device_mac = data["deviceMac"]
              sensor_mac = data["sensorMac"]
              status = data["nodeStatus"]
              #ActiveNode.find_or_create_by(:device_mac => device_mac, :ip => ip, :sensor_mac => sensor_mac)
              node = ActiveNode.where(:device_mac => device_mac)
              if node.blank?
                node = ActiveNode.create(
                  :device_mac => device_mac, :ip => ip, :sensor_mac => sensor_mac
                )
                node_hash = node.serializable_hash(:except => 'created_at')
              else
                node = node.take
                node.touch();
                node.update(ip: ip, sensor_mac: sensor_mac)
                node_hash = node.serializable_hash(:only => ['id', 'ip', 'sensor_mac', 'updated_at'])
              end
              WebsocketHandler.broadcast({ topic: 'node', node: node_hash })
              if !status.nil?
                node_hash = {id: node.id, status: status}
                WebsocketHandler.broadcast({ topic: 'node', node: node_hash })
              end
            when 'data'
              sensor_mac = topics[2]
              node = ActiveNode.where(:device_mac => device_mac)
              if node.any?
                node = node.take
                node.touch()
                node_hash = node.serializable_hash(:only => ['id', 'updated_at'])
                WebsocketHandler.broadcast({ topic: 'node', node: node_hash })
              end
            else
              puts "#{topic}: #{message}"
            end
          end
        end        
      end
      t.abort_on_exception = true
    end

    def checker_timer()
      t = Thread.new do
        interval = MQTTVisualizer.config[:interval] #seconds
        loop do
          now = DateTime.now.to_time.to_i
          sleep interval - (now%interval)
          check_status() 
        end
      end
      t.abort_on_exception = true
    end

    def check_status()
    end
  end

  extend Subscriber
end

