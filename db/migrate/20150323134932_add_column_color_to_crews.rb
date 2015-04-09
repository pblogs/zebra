class AddColumnColorToCrews < ActiveRecord::Migration
  def change
    add_column :crews, :color, :string, default: '#3a87ad'
    Crew.all.each do |crew|
      color = "%06x" % (rand * 0xffffff)
      crew.update_attributes(color: "##{color}")
    end
  end
end
