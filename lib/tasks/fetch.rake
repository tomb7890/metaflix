namespace :fetch do
  desc "Get articles from news site "
  task :new_movies => :environment do
    fd = Fetchdata.new
    fd.get_movies
  end
end
