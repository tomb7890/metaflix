require_relative '../spec_helper'

describe "Newflix" do

  
  let(:n) { Newflix.new  }

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/newflix_cassettes'
  end

  before do
    VCR.insert_cassette 'movie', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it 'must find known good title in today\'s list' do
    expected = 'Only the Brave'
    firstpage = n.page(1)
    list_of_movie_titles = firstpage.map { |m| m['title'] }
    expect(list_of_movie_titles).to include(expected)
    
    mymovie = firstpage.find { |m| m['title'] == expected }
    expect(mymovie['year']).to eq('2017')
  end

  it 'must find known good title in list of another page' do
    expected = 'Training Day'
    list_of_movies = n.page(7).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end
  
  it 'must find known good title in list of third page' do
    expected = 'El Camino: A Breaking Bad Movie'
    list_of_movies = n.page(11).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end

end 
