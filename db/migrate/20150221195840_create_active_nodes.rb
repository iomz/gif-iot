class CreateActiveNodes < ActiveRecord::Migration
  def change
    create_table :active_nodes do |t|
      t.string :mac
      t.string :ip
      t.timestamps :null => true
    end
  end
end
