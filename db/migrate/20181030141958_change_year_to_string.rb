class ChangeYearToString < ActiveRecord::Migration

  def self.up
    change_column :movies, :year, :string
  end

  def self.down
    change_column :movies, :year, :date
  end
end
