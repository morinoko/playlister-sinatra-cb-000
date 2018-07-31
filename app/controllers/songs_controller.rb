require 'rack-flash'

class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  post '/songs' do
    @song = Song.create(params[:song])

    if !params[:artist][:name].empty?
      artist_name = params[:artist][:name]

      @artist = Artist.find_by(name: artist_name) || Artist.create(name: artist_name)
      @song.artist = @artist
    end

    if !params[:genre][:name].empty?
      genre_name = params[:genre][:name].downcase

      @genre = Genre.find_by(name: genre_name) || Genre.create(name: genre_name)
      @song.genres << @genre
    end

    @song.save

    flash[:notice] = "Successfully created song."
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

  post '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    @song.update(params[:song])

    if !params[:artist][:name].empty?
      artist_name = params[:artist][:name]

      @artist = Artist.find_by(name: artist_name) || Artist.create(name: artist_name)
      @song.artist = @artist
    end

    if !params[:genre][:name].empty?
      genre_name = params[:genre][:name].downcase

      @genre = Genre.find_by(name: genre_name) || Genre.create(name: genre_name)
      @song.genres << @genre
    end
    
    @song.save

    flash[:notice] = "Successfully updated song."
    redirect to "songs/#{@song.slug}"
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @artists = Artist.all
    @genres = Genre.all

    erb :'songs/edit'
  end

end
