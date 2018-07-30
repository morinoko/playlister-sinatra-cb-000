class SongsController < ApplicationController
  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  post '/songs' do
    @song = Song.create(params[:song])

    if params[:artist][:name]
      artist_name = params[:artist][:name]

      @artist = Artist.find_by(name: artist_name) || Artist.create(name: artist_name)
      @song.artist = @artist
    end

    if params[:genre][:name]
      genre_name = params[:genre][:name].downcase

      @genre = Genre.find_by(name: genre_name) || Genre.create(name: genre_name)
      @song.genres << @genre
    end

    @song.save

    redirect to "songs/#{@song.slug}"
  end

  get '/songs/new' do
    @artists = Artist.all
    @genres = Genre.all
    erb :'songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end
end
