require_relative "./newflix"

class Fetchdata

  def get_movies
    n = Newflix.new 
    (1...6).each do |p|
      movie_list = n.page(p)
      movie_list.each do |movie|
        begin
          o = OMDB.new(movie['title'])
          unless o.profile.key?("Error")
            movie['Metascore'] = o.Metascore
            movie['imdbRating'] = o.imdbRating
            movie['plot'] = o.Plot 
            create_db_entry(movie)
          end
        end
      end
    end
  end

  private

  def create_db_entry(attrs)
    unless Movie.find_by(description: attrs['description'])

      Movie.create(title:  attrs['title'], year: attrs['year'],
                 description: attrs['plot'],
                 launchurl: attrs['launchurl'],
                 imgurl: attrs['imgurl'],
                 imdbscore: attrs['imdbRating'],
                 metascore: attrs['Metascore']) unless Movie.find_by(description: attrs['description'])
    end
  end
end
