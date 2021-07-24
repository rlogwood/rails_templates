class PagesController < ApplicationController
  def index
    render locals: { boards: Board.all }
  end
end
