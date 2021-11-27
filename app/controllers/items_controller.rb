class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_item_not_found
  wrap_parameters format: []

  def index
    if params[:user_id]
      items = User.find(params[:user_id]).items
      render json: items
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find(params[:id])
    render json: item
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item, status: :created
  end

  private

  def render_item_not_found(error)
    render json: error, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
