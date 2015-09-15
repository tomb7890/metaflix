require 'rails_helper'

RSpec.describe "Movies", type: :request do
  describe "GET /movies" do

    it "display some movies"  do
      visit movies_path
      expect(page).to have_content("Clouds of Sils Maria")
    end
  end
end
