module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :set_project, only: [ :show, :update, :destroy ]

      def index
        projects = Project.all
        render json: { data: projects.map { |p| { attributes: p } } }, status: :ok
      end

      def show
        render json: { data: { attributes: @project } }, status: :ok
      end

      def create
        @project = Project.new(project_params)
        if @project.save
          render json: { data: { attributes: @project } }, status: :created
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @project.update(project_params)
          render json: { data: { attributes: @project } }, status: :ok
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @project.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(
          :name,
          :description,
          :ordinance_number,
          :municipality,
          :company_id
          )
      end
    end
  end
end
