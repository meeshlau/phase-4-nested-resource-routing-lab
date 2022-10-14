class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # def index 
  #   binding.pry
  #   user = User.find_by(id: params[:user_id])
    
  #   if user
  #     render json: user.items
  #   elsif params[:user_id]
  #     render json: { error: "User not found"}, status: :not_found
  #   else
  #      items = Item.all
  #      render json: items, include: :user
  #   end 
  # end 

  def index
    if user = User.find_by(id: params[:user_id])
      render json: user.items
    elsif params[:user_id]
      render json: { error: "User not found" }, status: :not_found
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    if item = Item.find_by(id: params[:id])
      render json: item
    else 
      render_not_found_response
    end 
  end

  def create
    find_user = User.find_by(id: params[:user_id])

    if find_user
      new_item = Item.create(
        name: params[:name],
        description: params[:description],
        price: params[:price],
        user_id: find_user.id)
      render json: new_item, status: :created
    else
      render_not_found_response
    end
  end

  private

  def render_not_found_response
    render json: { error: "Not found" }, status: :not_found
  end



end
