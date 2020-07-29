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

  it 'must find known good title in list of another page' do
    expected = 'Starred Up'
    list_of_movies = n.page(0).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end

  it 'must find known good title in list of another page' do
    expected = 'Little Children'
    list_of_movies = n.page(4).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end
  
  it 'must find known good title in list of third page' do
    expected = 'Steal a Pencil for Me'
    list_of_movies = n.page(2).map { |m| m['title'] }
    expect(list_of_movies).to include(expected)
  end
 
end 
