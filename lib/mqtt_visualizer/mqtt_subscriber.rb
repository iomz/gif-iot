module MQTTVisualizer
  module MQTTSubscriber
    def start_subscribe()
      puts "* Starting to subscribe"
      t = Thread.new do
        MQTT::Client.connect('lain.sfc.wide.ad.jp') do |c|
          c.get('gif-iot/ip') do |topic,message|
            puts "#{topic}: #{message}"
          end
        end        
      end
      t.abort_on_exception = true
    end
  end

  extend MQTTSubscriber
end

