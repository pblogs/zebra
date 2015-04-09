class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :crew_id
      t.references :eventable, polymorphic: true
      t.date     :started_on
      t.date     :completed_on
      t.timestamps
    end
  end
end
