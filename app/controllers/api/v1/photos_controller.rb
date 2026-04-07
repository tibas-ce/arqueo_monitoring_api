module Api
  module V1
    class PhotosController < ApplicationController
      before_action :set_sheet

      def create
        photo = @sheet.photos.new(photo_params)

        if photo.save
          render json: { data: { attributes: photo } }, status: :created
        else
          render json: { errors: photo.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        photo = @sheet.photos.find(params[:id])
        photo.destroy
        head :no_content
      end

      private

      def set_sheet
        @sheet = MonitoringSheet.find(params[:monitoring_sheet_id])
      end

      def photo_params
        params.require(:photo).permit(:caption, :coord_e, :coord_n, :position)
      end
    end
  end
end
