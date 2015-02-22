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
              if ActiveNode.where(:device_mac => device_mac).empty?
                ActiveNode.create(:device_mac => device_mac, :ip => ip, :sensor_mac => sensor_mac)
              else
                ActiveNode.find_by_device_mac(device_mac).update(ip: ip, sensor_mac: sensor_mac)
              end
            when 'data'
              sensor_mac = topics[2]
              unless ActiveNode.where(:sensor_mac => sensor_mac).empty?
                ActiveNode.find_by_sensor_mac(sensor_mac).touch()
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

