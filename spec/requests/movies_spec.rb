require 'rails_helper'

RSpec.describe "Movies", type: :request do

  before do
    @movietitle = "Back to the Future"
    @movie = Movie.create :title => @movietitle,
                          metascore: 89,
                          imdbscore: 99
  end

  describe "GET /movies" do
    it "display some movies"  do
      visit movies_path
      expect(page).to have_content(@movietitle)
    end

  end

end
