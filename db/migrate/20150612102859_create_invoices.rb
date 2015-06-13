class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :customer_name
      t.string :invoice_number
      t.string :order_number
      t.date :invoice_date, default: Date.today
      t.date :due_date, default: Date.today
      t.text :customer_notes
      t.text :terms_and_cond
      t.string :emails
      t.integer :status, default: 0
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
