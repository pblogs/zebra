class CreateCompletions < ActiveRecord::Migration
  def self.up
    create_table :completions, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :completions
  end
end
