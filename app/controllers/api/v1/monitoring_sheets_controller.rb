module Api
  module V1
    class MonitoringSheetsController < ApplicationController
      before_action :set_sheet, only: [ :show, :update, :destroy, :export_pdf ]

      def index
        sheets = MonitoringSheet.all
        render json: { data: sheets.map { |s| { attributes: s } } }, status: :ok
      end

      def show
        render_sheet(@sheet)
      end

      def create
        sheet = MonitoringSheet.new(sheet_params)

        if sheet.save
          render_sheet(sheet, status: :created)
        else
          render_errors(sheet)
        end
      end

      def update
        if @sheet.update(sheet_params)
          render_sheet(@sheet)
        else
          render_errors(@sheet)
        end
      end

      def destroy
        @sheet.destroy

        head :no_content
      end

      def export_pdf
        pdf = MonitoringSheetPdfService.new(@sheet).generate
        send_data pdf,
                  filename: "monitoramento_#{@sheet.monitoring_date}_lote#{@sheet.lot}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end

      private

      def set_sheet
        @sheet = MonitoringSheet.find(params[:id])
      end

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
          :coordinate_system,
          :project_id
        )
      end

      def render_sheet(sheet, status: :ok)
        render json: { data: { attributes: sheet } }, status: status
      end

      def render_errors(sheet)
        render json: {
          errors: sheet.errors.full_messages
          }, status: :unprocessable_entity
      end
    end
  end
end
