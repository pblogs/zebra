class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.text :terms_and_conditions
      t.timestamps
    end

    Setting.create(terms_and_conditions: 'Terms & Conditions')
  end
end
