class ChangeImdbscoreColumnToDecimal < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :movies do |t|
        dir.up   { t.change :imdbscore, :decimal }
        dir.down { t.change :imdbscore, :integer }
      end
    end
  end
end
