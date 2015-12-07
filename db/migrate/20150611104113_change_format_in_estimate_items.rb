class ChangeFormatInEstimateItems < ActiveRecord::Migration
  def up
    change_column :estimate_items, :quantity, :decimal
  end

  def down
    change_column :estimate_items, :quantity, :integer
  end
end
