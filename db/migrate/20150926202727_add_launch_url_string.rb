class AddLaunchUrlString < ActiveRecord::Migration
  def change
      add_column :movies, :launchurl, :string
  end
end
