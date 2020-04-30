     
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'pg'
require 'httparty'

require_relative 'models/meals.rb'
require_relative 'models/user.rb'

enable :sessions

def logged_in?
  if session[:user_id]
    return true
  else
    return false
  end
end

reset_planner()

get '/' do
  meals = all_meals()

  #Code to be written here to get URI from PSQL and use to link back to meal_details, so user can click on selection and take them back to meal_details page

  erb :index, locals: {meals: meals}
end

get '/new_meal' do
  erb :new_meal
end

get '/select_meal' do

  edamam_app_id = "7b26061b"
  edamam_app_key = "fdda13e00a7171c133e27130253ac408"
  
  url = "https://api.edamam.com/search?q=#{params["meal"]}&app_id=#{edamam_app_id}&app_key=#{edamam_app_key}&from=0&to=10"

  result = HTTParty.get(url)

  #output is an array of hashes
  output_options = result["hits"]

  meals = []
  num = 0

   output_options.each do |meal|
    
    meals[num] = {
      "label" => meal["recipe"]["label"],
      "uri_code" => meal["recipe"]["uri"].split('_')[1]
    }
    num += 1
  end

  erb(:select_meal, locals: {meals: meals, result: result})

end

get '/meal_details' do

  edamam_app_id = "7b26061b"
  edamam_app_key = "fdda13e00a7171c133e27130253ac408"
  
  url = "https://api.edamam.com/search?r=http%3A%2F%2Fwww.edamam.com%2Fontologies%2Fedamam.owl%23recipe_#{params["r"]}&app_id=#{edamam_app_id}&app_key=#{edamam_app_key}"

  result = HTTParty.get(url)[0]

  #Extract health types from the array inside the hash
  health_types = []

  result["healthLabels"].each do |type|
    health_types.push(type)
  end

  #Extract ingredients from the array inside the hash
  ingredients = []

  result["ingredientLines"].each do |ingredient|
    ingredients.push(ingredient)
  end

  #check if we need this line of code
  nutrition = result["totalNutrients"]
  nutrients = {}

  #Need to return our hash values to 2.dp, to do this we need to create a new hash from our API get request
  nutrition.each do |key, value|
  
    nutrients[key] = value["quantity"].round(2)
  end

  calories = result["calories"].round()

  uri = result["uri"].split('_')[1]

  erb(:meal_details, locals: {meal_details: result, health_types: health_types, ingredients: ingredients, calories: calories, nutrients: nutrients, uri: uri})
end

patch '/meals' do
  update_dish(params["day_of_week"], params["meal_course"], params["label"])
  add_dish_details(params["label"], params["uri"])
  redirect "/"
end

patch '/reset_planner' do
  reset_planner()
  redirect "/"
end

get '/add_takeout' do
  erb :add_takeout
end

get '/login' do
  erb :login
end

post '/login' do
  user = find_user_by_email( params[:email] )
  if user && BCrypt::Password.new(user["password_digest"]) == params[:password]
    session[:user_id] = user['id']
    redirect "/"
  else
    erb :login
  end
end

delete '/logout' do
  session[:user_id] = nil
  redirect "/login"
end

get '/calc_budget' do
    erb :calculate_budget
end