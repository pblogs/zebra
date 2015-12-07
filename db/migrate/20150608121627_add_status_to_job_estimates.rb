class AddStatusToJobEstimates < ActiveRecord::Migration
  def change
    add_column :job_estimates, :state, :integer, default: 1
  end
end
