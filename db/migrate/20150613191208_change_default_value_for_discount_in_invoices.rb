class ChangeDefaultValueForDiscountInInvoices < ActiveRecord::Migration
  def up
    change_column :invoices, :discount, :decimal, default: 0
  end

  def down
  end
end
