
class MoviesController < ApplicationController
	before_action :set_movie, only: %i[ show edit update destroy ]

	# GET /movies or /movies.json
	def index

		sort = params[:sort] || session[:sort]
		case sort
		when 'title'
			ordering,@title_header = {:title => :asc}, 'hilite'
		when 'release_date'
			ordering,@date_header = {:release_date => :asc}, 'hilite'
		end
		@all_ratings = ['G', 'PG', 'PG-13', 'R']
		@selected_ratings = params[:ratings] || session[:ratings] || {}
		if @selected_ratings == {}
			@selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
		end
		if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
			session[:sort] = sort
			session[:ratings] = @selected_ratings
		end
		@movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
	end
	# @all_ratings = ['G', 'PG', 'PG-13', 'R']
	# if params[:ratings]
	#   @movies = Movie.where(rating: params[:ratings].keys)
	# end
	# @ratings = Hash.new
	# @movies = Movie.all
	# if params[:title_sort] == "on"
	#   @movies = Movie.order("title asc")
	#   @movie_hl = "hilite"
	# elsif params[:date_sort] == "on"
	#   @movies = Movie.order("release_date asc")
	#   @date_hl = "hilite"
	# else
	#   # @movies = Movie.all
	#   params[:ratings] ? @movies = Movie.where(rating: params[:ratings].keys) :
	#   @movies = Movie.all 
	# end
		
	# GET /movies/1 or /movies/1.json
	def show
		id = params[:id] 
		@movie = Movie.find(id) 
	end

	# GET /movies/new
	def new
		@movie = Movie.new
	end

	# GET /movies/1/edit
	def edit
	end

	# POST /movies or /movies.json
	def create
		@movie = Movie.new(movie_params)

		respond_to do |format|
			if @movie.save
				format.html { redirect_to @movie, notice: "Movie was successfully created." }
				format.json { render :show, status: :created, location: @movie }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { render json: @movie.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /movies/1 or /movies/1.json
	def update
		respond_to do |format|
			if @movie.update(movie_params)
				format.html { redirect_to @movie, notice: "Movie was successfully updated." }
				format.json { render :show, status: :ok, location: @movie }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { render json: @movie.errors, status: :unprocessable_entity }
			end
		end
	end
	# DELETE /movies/1 or /movies/1.json
	def destroy
		@movie.destroy
		respond_to do |format|
			format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_movie
		@movie = Movie.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def movie_params
		params.require(:movie).permit(:title, :rating, :description, :release_date)
	end
end 

