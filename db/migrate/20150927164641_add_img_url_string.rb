class AddImgUrlString < ActiveRecord::Migration
  def change
      add_column :movies, :imgurl, :string
  end
end
