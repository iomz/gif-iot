module GIFIoT
  module Core
    def config
      @config ||= {}
    end

    def load_config
      YAML.load_file(File.expand_path('../../../config.yml', __FILE__)).each{ |k,v| config[k.to_sym] = v }
    end
  end

  extend Core
  GIFIoT.load_config
end

