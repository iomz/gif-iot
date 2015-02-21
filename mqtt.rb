require './lib/mqtt-visualizer'

# Subscribe example
MQTT::Client.connect('lain.sfc.wide.ad.jp') do |c|
  c.get('gif-iot/ip') do |topic,message|
    puts "#{topic}: #{message}"
  end
end
