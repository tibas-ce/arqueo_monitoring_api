module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :set_company, only: [ :show, :update, :destroy ]

      def index
        companies = Company.order(name: :asc)
        render json: { data: companies.map { |c| { attributes: c } } }, status: :ok
      end

      def show
        render json: { data: { attributes: @company } }, status: :ok
      end

      def create
        @company = Company.new(company_params)
        if @company.save
          render json: { data: { attributes: @company } }, status: :created
        else
          render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @company.update(company_params)
          render json: { data: { attributes: @company } }, status: :ok
        else
          render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @company.destroy
        head :no_content
      end

      private

      def set_company
        @company = Company.find(params[:id])
      end

      def company_params
        params.require(:company).permit(:name, :cnpj, :email, :phone)
      end
    end
  end
end
