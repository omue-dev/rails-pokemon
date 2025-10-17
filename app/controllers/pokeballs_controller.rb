class PokeballsController < ApplicationController
  def create
    @pokeball = Pokeball.new(pokeball_params)
    @pokemon = Pokemon.find(params[:pokemon_id])
    @pokeball.pokemon = @pokemon

    @trainer = Trainer.find(pokeball_params[:trainer_id])
    @pokeball.trainer = @trainer

    if @pokeball.save
      redirect_to @pokeball.trainer, notice: "Caught!"
    else
      render "pokemons/show", status: :unprocessable_entity
    end
  end

  private

  def pokeball_params
    params.require(:pokeball).permit(:trainer_id, :pokemon_id, :location, :caught_on)
  end
end
