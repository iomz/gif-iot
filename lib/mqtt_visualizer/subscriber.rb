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
              mac = data["mac"]
              p [ip, mac]
              if ActiveNode.where(:mac => mac).empty?
                ActiveNode.create(:mac => mac, :ip => ip)
              else
                ActiveNode.find_by_mac(mac).update(ip: ip)
              end
            when 'data'
              mac = topics[2]
              #p mac
              unless ActiveNode.where(:mac => mac).empty?
                p mac
                ActiveNode.find_by_mac(mac).touch()
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

