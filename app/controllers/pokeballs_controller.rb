class PokeballsController < ApplicationController
  # This action handles both:
  # - catching a Pokémon from a Trainer page
  # - catching a Pokémon from a Pokémon page

  # def create_from_trainer # we then need the url in the form
  #    @pokeball = Pokeball.new(pokeball_params)

  #    @pokemon = Pokemon.find(params[:pokeball][:pokemon_id])
  #    @pokeball.pokemon = @pokemon
  #    @trainer = Trainer.find(params[:trainer_id])
  #    @pokeball = @trainer. = @trainer
  # end

  def create
    if params[:trainer_id]
      # Submitted by Trainer Detail Page
      # We first find the trainer by ID from the URL
      @trainer = Trainer.find(params[:trainer_id])
      # Create a new Pokeball that belongs to this trainer
      @pokeball = @trainer.pokeballs.new(pokeball_params)
      # Find the Pokémon that the user selected in the form.
      # params[:pokeball][:pokemon_id] comes from the dropdown field named "pokeball[pokemon_id]"
      # This gives us the ID of the chosen Pokémon, for example "36".
      # We use Pokemon.find(...) to look it up in the database and get the actual Pokémon object.
      # Then we assign it to this Pokeball, connecting them together in memory before saving.
      @pokeball.pokemon = Pokemon.find(params[:pokeball][:pokemon_id])

    elsif params[:pokemon_id]
      # Case 2: Submitted by Pokemon Detail Page
      # We first find the Pokémon by ID from the URL
      @pokemon = Pokemon.find(params[:pokemon_id])
      # Create a new Pokeball that belongs to this Pokémon
      @pokeball = @pokemon.pokeballs.new(pokeball_params)
      # The form on a Pokémon page also includes a dropdown to choose a trainer
      # So we find the trainer from the form data
      @trainer = Trainer.find(pokeball_params[:trainer_id])
      # And link this Pokeball to that trainer
      @pokeball.trainer = @trainer
    end

    # 50% chance to catch the Pokémon
    if rand < 0.5
      # Catch failed
      redirect_to @trainer, alert: "Oh no! The Pokémon escaped!"
      return
    end

    # Try to save the Pokeball in the database
    if @pokeball.save
      # Success — go back to the trainer’s page
      redirect_to @trainer, notice: "Caught!"
    else
      # Something went wrong — show the form again with an error status
      render "trainers/show", status: :unprocessable_entity
    end
  end

  def destroy
    @trainer = Trainer.find(params[:trainer_id])
    @pokeball = @trainer.pokeballs.find(params[:id])
    pokemon = @pokeball.pokemon
    @pokeball.destroy
    redirect_to @trainer, notice: "You released #{pokemon.name} to the wild!"
  end

  private

  # Only allow the parameters we actually need for creating a Pokeball
  def pokeball_params
    params.require(:pokeball).permit(:location, :caught_on)
  end
end
