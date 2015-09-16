require 'rails_helper'

RSpec.describe "Movies", type: :request do

  before do
      @movie1 = Movie.create :title => "Back to the Future"
  end

  describe "GET /movies" do
    it "display some movies"  do
      visit movies_path
      expect(page).to have_content("Back to the Future")
    end

    it "creates a new movie" do
      visit movies_path
      fill_in 'Title', :with => "Citizen Kane"
      click_button 'Create Movie'
      expect(current_path).to eq(movies_path)
      expect(page).to have_content("Citizen Kane")
      save_and_open_page
    end
  end

  describe "PUT /movies" do
    it "edits a movie" do

      taxi_driver_title = 'Taxi Driver'
      Movie.destroy_all
      @movie1 = Movie.create :title => taxi_driver_title

      visit movies_path
      click_link('Edit')

      expect(current_path).to eq(edit_movie_path(@movie1))

      expect(find_field("Title").value ).to eq(taxi_driver_title)

      updated_movie_text="Raging Bull"
      fill_in 'Title', :with  => updated_movie_text
      click_button 'Update Movie'

      expect(page).to have_content(updated_movie_text)
    end
  end
end
