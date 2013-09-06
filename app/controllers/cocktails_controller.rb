class CocktailsController < ApplicationController
  before_action :set_cocktail, only: [:show, :edit, :update, :destroy]

  # GET /cocktails
  # GET /cocktails.json
  def index
    input = params[:ingredients]

    require 'nokogiri'
    require 'uri-handler'
    require 'open-uri'

    input = input.to_uri
    doc = Nokogiri::HTML(open("http://www.webtender.com/cgi-bin/search?name=&ingr=#{input}&what=drink&show=10&verbose=on"))
    index = 0

    drinknames = []
    ingredients = []
    cocktails = Hash.new

    doc.css("td[width='90%']").each do |node|
      # puts node.xpath('/a').text
      drinknames[index] =  node.css('a').text
      ingredients[index] = node.css("small")[1].text

      cocktails[drinknames[index]] = [ingredients[index]]

      index += 1
    end
    
    respond_to do |format|
      format.json { render :json => cocktails }
    end
  end


  def home
  end

end
