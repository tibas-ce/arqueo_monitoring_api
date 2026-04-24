class ApplicationController < ActionController::API
  include Pagination
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render json: { error: "Ficha não encontrada!" }, status: :not_found
  end
end
