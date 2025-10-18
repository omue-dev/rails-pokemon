class TrainersController < ApplicationController
  before_action :set_trainer, only: [:show]

  def index
    @trainers = Trainer.all
  end

  def show
    @pokeball = Pokeball.new
  end

  def new
    @trainer = Trainer.new
  end

  def create
    @trainer = Trainer.new(trainer_params)

    if @trainer.save
      redirect_to trainers_path, notice: "Added new Trainer"
    else
      redirect_to :new, status: :unprocessable_entity
    end
  end



  private

  def set_trainer
    @trainer = Trainer.find(params[:id])
  end

  def trainer_params
    params.require(:trainer).permit(:name, :age, :photo)
  end
end
