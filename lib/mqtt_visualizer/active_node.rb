module MQTTVisualizer
  class ActiveNode < ActiveRecord::Base
    validates_presence_of :device_mac
  end
end
