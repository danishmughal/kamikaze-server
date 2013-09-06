class CocktailsController < ApplicationController
  before_action :set_cocktail, only: [:show, :edit, :update, :destroy]

  # GET /cocktails
  # GET /cocktails.json
  def index
    ingredients = params[:ingredients]
    if params[:limit]
      searchlimit = params[:limit]
    else
      searchlimit = '10'
    end

    require 'nokogiri'
    require 'uri-handler'
    require 'open-uri'

    ingredients = ingredients.to_uri
    doc = Nokogiri::HTML(open("http://www.webtender.com/cgi-bin/search?name=&ingr=#{ingredients}&what=drink&show=#{searchlimit}&verbose=on"))
    index = 0

    drinknames = []
    ings = []
    cocktails = Hash.new

    doc.css("td[width='90%']").each do |node|
      # puts node.xpath('/a').text
      drinknames[index] =  node.css('a').text
      ings = node.css("small")[1].text

      ings.gsub!('Ingredients: ', '')
      ings = ings.split(', ')


      cocktails[drinknames[index]] = [ings]

      index += 1
    end

    respond_to do |format|
      format.json { render :json => cocktails }
    end
  end


  def home
  end

end
