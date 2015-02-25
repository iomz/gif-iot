module GIFIoT
  class ActiveNode < ActiveRecord::Base
    validates_presence_of :device_mac
    validates_uniqueness_of :device_mac
  end
end
