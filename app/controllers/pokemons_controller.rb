class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:show]

  def index
    if params[:query].present?
      @pokemons = Pokemon.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
    else
      @pokemons = Pokemon.all
      @random = Pokemon.all.sample
    end
  end

  def show
    @pokeball = Pokeball.new
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
