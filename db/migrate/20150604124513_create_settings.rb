class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :company_name
      t.string :city, :address, :postal_code, :state, :phone, :fax
      t.text :terms_and_conditions
      t.attachment :logo
      t.timestamps
    end

    Setting.create(company_name: "Zebra",terms_and_conditions: 'Terms & Conditions')
  end
end
