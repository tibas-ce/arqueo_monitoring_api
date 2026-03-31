module Api
  module V1
    class MonitoringSheetsController < ApplicationController
      def create
        sheet = MonitoringSheet.new(sheet_params)

        if sheet.save
          render json: { data: { attributes: sheet } }, status: :created
        else
          render json: { data: { errors: sheet.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      private

      def sheet_params
        params.require(:monitoring_sheet).permit(
          :monitoring_date,
          :activity,
          :stake_interval,
          :lot,
          :start_x,
          :start_y,
          :end_x,
          :end_y,
          :work_status,
          :occurrence_evaluation,
          :coordinate_system
        )
      end
    end
  end
end
