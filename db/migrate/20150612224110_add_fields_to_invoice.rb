class AddFieldsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :discount, :integer
    add_column :invoices, :shipping_charges, :decimal, precision: 8, scale: 2
    add_column :invoices, :sub_total_amount, :decimal, precision: 8, scale: 2
  end
end
