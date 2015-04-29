class AddDiscountToJobEstimates < ActiveRecord::Migration
  def change
    remove_column :estimate_items, :discount
    add_column :job_estimates, :estimate, :string
    add_column :job_estimates, :sub_total_amount, :decimal, default: 0
    add_column :job_estimates, :discount, :decimal, default: 0
    add_column :job_estimates, :shipping_charges, :decimal, default: 0
  end
end
