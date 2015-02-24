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

    def call(env)
      @app.call(env)
    end
  end
end
 
