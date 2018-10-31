require_relative "./newflix"

class Fetchdata

  def get_movies
    n = Newflix.new 
    (1...6).each do |p|
      movie_list = n.page(p)
      movie_list.each do |movie|
        begin
          response = OMDB.new(movie['title'], movie['year'])
          movie['Metascore'] = response.Metascore
          movie['imdbRating'] = response.imdbRating
          create_db_entry(movie)
        rescue => e
          puts "Fetchdata Exception: #{e}  "
        end
      end
    end
  end

  private

  def create_db_entry(attrs)
    Movie.create(title:  attrs['title'], year: attrs['year'],
                 description: attrs['description'],
                 launchurl: attrs['launchurl'],
                 imgurl: attrs['imgurl'],
                 imdbscore: attrs['imdbRating'],
                 metascore: attrs['Metascore']) unless Movie.find_by(description: attrs['description'])
  end

end
