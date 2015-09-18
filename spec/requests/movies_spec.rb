require 'rails_helper'

RSpec.describe "Movies", type: :request do

  before do
    @movietitle = "Back to the Future"
    @movie = Movie.create :title => @movietitle
  end

  describe "GET /movies" do
    it "display some movies"  do
      visit movies_path
      expect(page).to have_content(@movietitle)
    end

    it "creates a new movie" do
      visit movies_path
      fill_in 'Title', :with => "Citizen Kane"
      click_button 'Create Movie'
      expect(current_path).to eq(movies_path)
      expect(page).to have_content("Citizen Kane")
    end

    describe "PUT /movies" do
      it "edits a movie" do
        visit movies_path
        click_link('Edit')

        expect(current_path).to eq(edit_movie_path(@movie))
        expect( find_field('Title').value).to eq(@movietitle)

        updated_movie_text="Raging Bull"
        fill_in 'Title', :with  => updated_movie_text
        click_button 'Update Movie'
        expect(page).to have_content(updated_movie_text)
      end
    end

    it "should not update an empty task" do
      visit movies_path
      click_link('Edit')

      fill_in 'Title', :with  => ''
      click_button 'Update Movie'

      expect(current_path).to eq(edit_movie_path(@movie))
      expect(page).to have_content("There was an error updating your movie.")
    end
  end

  describe "DELETE /movies" do
    it "should delete a movie" do
      visit movies_path

      expect(current_path).to eq(movies_path)

      within("#movie_#{@movie.id}") do
        click_link "Delete"
      end
      expect(page).to have_content("Movie has been deleted")
    end
  end
end
