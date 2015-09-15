class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.date :year
      t.text :description
      t.integer :imdbscore
      t.integer :metascore

      t.timestamps null: false
    end
  end
end
