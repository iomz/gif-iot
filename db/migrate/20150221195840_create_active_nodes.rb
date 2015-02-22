class CreateActiveNodes < ActiveRecord::Migration
  def change
    create_table :active_nodes do |t|
      t.string :device_mac
      t.string :sensor_mac
      t.string :ip
      t.timestamps :null => true
    end
  end
end
