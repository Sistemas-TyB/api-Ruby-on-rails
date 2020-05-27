class Api::V1::HomeController < ApplicationController
  def index
    @model = {name:"Juan", hobby:"Futbol"} 
    @work = {name:"TYB", lenguaje:"rubyrails"} 
    
    #render "api/home/index"
  end
end
