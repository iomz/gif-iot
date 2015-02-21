module MQTTVisualizer
  class ActiveNode < ActiveRecord::Base
    validates_presence_of :id
  end
end
