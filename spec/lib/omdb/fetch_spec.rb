require_relative '../../spec_helper'

require 'net/http'
require 'webmock'

describe 'default instance attributes' do

  let(:movie) { OMDB::Lookup.new('Star Wars') }

  it 'must have a title attribute' do
    expect(movie).to respond_to :title
  end

  it 'must have the right title' do
    expect(movie.title).to eq 'Star Wars'
  end

end

describe 'GET profile' do

  let(:movie) { OMDB::Lookup.new('Star Wars') }

  api_key = ENV['OMDB_API_KEY']
  before do
    VCR.insert_cassette 'movie', :record => :new_episodes
  end
  after do
    VCR.eject_cassette
  end
  it 'records the fixture' do
    OMDB::Lookup.get("/?t=star+wars&plot=full&apikey=#{api_key}")
  end   

  it 'must have a profile method' do
    expect(movie).to respond_to :profile
  end

  it 'must parse the api response from JSON to Hash' do
    expect(movie.profile).to be_instance_of Hash
  end

  it 'must perform the request and get the data' do
    expect(movie.profile['Genre']).to eq('Action, Adventure, Fantasy, Sci-Fi')
  end

  describe 'dynamic attributes' do
    
    before do
      movie.profile
    end
    
    it 'must return the attribute value if present in profile' do
      expect(movie.Metascore).to eq '90'
    end
    
    it 'must raise method missing if attribute is not present' do
      expect {movie.foo_attribute}.to raise_error(NoMethodError)
    end
  end

  describe 'caching' do

    before do
      movie.profile
      stub_request(:any, /.*omdbapi.com/).to_timeout
    end

    it 'must cache the profile' do
      expect(movie.profile).to be_instance_of Hash
    end

    it 'must refresh the profile if forced' do
      expect {movie.profile(true)}.to raise_error(Timeout::Error)
    end
  end

end
