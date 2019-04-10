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
    expected = 'The Five-Year Engagement'
    list_of_movies = n.page(5).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
    certain_women = n.page(5).find { |m| m['title'] == expected }
    expect(certain_women['year']).to eq('2012')
  end
  
  it 'must find known good title in list of another page' do
    expected = 'Billy Elliot'
    list_of_movies = n.page(5).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end

  it 'must find known good title in list of another page' do
    expected = 'American Psycho'
    list_of_movies = n.page(6).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end

end 
