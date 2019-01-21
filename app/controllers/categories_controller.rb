class CategoriesController < ApplicationController
  def show
    ensure_logged_in
    @category = Category.find(params[:id])
  end
end