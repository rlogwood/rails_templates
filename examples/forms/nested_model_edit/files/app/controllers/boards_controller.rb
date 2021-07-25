class BoardsController < ApplicationController
  before_action :set_board, only: %i[show edit update destroy]

  def index
    render locals: { boards: Board.all }
  end

  def show
    render locals: { board: @board }
  end

  def new
    @board = Board.new
    render locals: { board: @board }
  end

  def edit
    render locals: { board: @board }
  end

  def create
  end

  def update
    # NOTE: using an intermediate variable for permitted parameters to allow for debugging
    permitted_params = board_params
    puts permitted_params
    # NOTE: uncomment byebug to examine params and permitted parameters
    # byebug
    respond_to do |format|
      if @board.update(permitted_params)
        format.html { redirect_to @board, notice: "Pet was successfully updated." }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_board
    @board = Board.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def board_params
    # list_attributes, task_attributes and steps_attributes will be recognized automatically
    # see fields_for usage in forms and accepts_nested_attributes for in models
    params.require(:board).permit(:name, :description,
                                  lists_attributes: [ :name, :id, :_destroy,
                                                      tasks_attributes: [ :summary, :description, :id, :_destroy,
                                                      steps_attributes: [ :order, :description, :id, :_destroy]]])

  end
end
