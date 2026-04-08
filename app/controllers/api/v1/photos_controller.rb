module Api
  module V1
    class PhotosController < ApplicationController
      before_action :set_sheet
      before_action :set_photo, only: :destroy

      def create
        photo = @sheet.photos.new(photo_params)

        if photo.save
          render json: { data: render_photo(photo) }, status: :created
        else
          render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @photo.destroy
        head :no_content
      end

      private

      def set_sheet
        @sheet = MonitoringSheet.find(params[:monitoring_sheet_id])
      end

      def set_photo
        @photo = @sheet.photos.find(params[:id])
      end

      def photo_params
        params.require(:photo).permit(:caption, :coord_e, :coord_n, :position, :image)
      end

      def render_photo(photo)
        {
          id: photo.id,
          type: "photo",
          attributes: {
            caption: photo.caption,
            coord_e: photo.coord_e,
            coord_n: photo.coord_n,
            position: photo.position,
            image_url: photo.image.attached? ? url_for(photo.image) : nil,
            created_at: photo.created_at
          }
        }
      end
    end
  end
end
