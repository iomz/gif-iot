module GIFIoT
  module Subscriber
    def start_subscribe()
      puts "* Starting to subscribe"
      t = Thread.new do
        MQTT::Client.connect(GIFIoT.config[:mqtt_broker]) do |c|
          c.get('gif-iot/#') do |topic,message|
            topics = topic.split('/')
            case topics[1]
            when 'status' # when status info received
              data = JSON.parse(message)
              device_mac = data["deviceMac"]
              sensor_mac = data["sensorMac"] || ""
              ip = (IPAddress.valid? data["ip"]) ? data["ip"] : ""
              status = data["nodeStatus"]
              # update device info in ActiveNode, create if not exist
              node = ActiveNode.find_or_create_by(:device_mac => device_mac)
              node.update(ip: ip, sensor_mac: sensor_mac)
              node_hash = node.serializable_hash(:except => 'created_at')
              # tell browsers to update new info
              WebsocketHandler.broadcast({ topic: 'node', node: node_hash })
              if !status.nil? # if the message contains status info
                node_hash = {id: node.id, status: status}
                WebsocketHandler.broadcast({ topic: 'node', node: node_hash })
              end
            when 'data' # when sensor data received
              data = JSON.parse(message)
              device_mac = data["deviceMac"]
              node = ActiveNode.where(:device_mac => device_mac)
              if node.any? # if the data is from a known device
                node = node.take
                node.touch()
                node_hash = node.serializable_hash(:only => ['id', 'sensor_mac', 'updated_at'])
                node_hash[:status] = 'active'
                WebsocketHandler.broadcast({ topic: 'node', node: node_hash })
                # trim irrelevant attributes to ingest Influxdb
                data.delete("ip")
                data.delete("sensorMac")
                data.delete("deviceMac")
                InfluxdbClient.ingest("gif"+node_hash['id'].to_s, data)
              elsif topics.length == 3 # if the data is from somewhere
                InfluxdbClient.ingest(topics[2], data)
              end
            else
              puts "[#{topic}]: #{message}"
            end
          end
        end        
      end
      t.abort_on_exception = true
    end

    def checker_timer()
      t = Thread.new do
        interval = GIFIoT.config[:interval] #seconds
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

