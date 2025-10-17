class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:show]

  def index
    @pokemons = Pokemon.all
  end

  def show
    @pokeball = Pokeball.new
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
