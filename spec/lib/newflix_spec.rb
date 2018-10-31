require_relative '../spec_helper'

describe "Newflix" do

  
  let(:n) { Newflix.new  }

  before do

    VCR.configure do |c|
      c.cassette_library_dir = 'spec/fixtures/newflix_cassettes'
    end

    VCR.insert_cassette 'movie', :record => :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it 'must find known good title in today\'s list' do
    expected = 'Certain Women'
    list_of_movies = n.page(0).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
    certain_women = n.page(0).find { |m| m['title'] == expected }
    expect(certain_women['year']).to eq('2016')
  end
  
  it 'must find known good title in list of another page' do
    expected = "God Knows Where I Am"
    list_of_movies = n.page(2).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end
  
  it 'must find known good title in list of page 6' do
    expected = 'The Kindergarten Teacher'
    list_of_movies = n.page(6).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end
  
end 
