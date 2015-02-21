module MQTTVisualizer
  class ActiveNode < ActiveRecord::Base
    validates_presence_of :mac
  end
end
