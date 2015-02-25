module GIFIoT
  class InfluxdbClient
    def initialize(app)
      @app = app
      @@influxdb = InfluxDB::Client.new GIFIoT.config[:influxdb]
    end

    def self.ingest(name, data)
      @@influxdb.write_point(name, data)
      #p [name, data]
    end

    def self.query_to_xml(name)
      begin
        @@influxdb.query 'select * from '+name+' limit 1' do |name, data|
          d = data[0]
          d.delete("sensorMac")
          d.delete("deviceMac")
          d.delete("ip")
          d.delete("sequence_number")
          return d.to_xml(:root => name)
        end
      rescue
        return {}.to_xml(:root => name)
      end
    end

    def call(env)
      @app.call(env)
    end
  end
end
 
