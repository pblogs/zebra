class AddColorToCompletion < ActiveRecord::Migration
  def change
    add_column :completions, :color, :string, default: '#3a87ad'
  end
end
