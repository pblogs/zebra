class ChangeDefaultValueForDiscountInInvoices < ActiveRecord::Migration
  def up
    change_column :invoices, :discount, :decimal, default: 0
    change_column :invoices, :invoice_date, :date, default: nil
    change_column :invoices, :due_date, :date, default: nil
  end

  def down
  end
end
