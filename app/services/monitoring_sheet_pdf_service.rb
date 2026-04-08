class MonitoringSheetPdfService
  def initialize(sheet)
    @sheet = sheet
  end

  def generate
    pdf = Prawn::Document.new

    font_path = Rails.root.join("app/assets/fonts/DejaVuSans.ttf").to_s
    font_bold = Rails.root.join("app/assets/fonts/DejaVuSans-Bold.ttf").to_s
    pdf.font_families.update(
      "DejaVu" => {
        normal: font_path,
        bold: font_bold,
        italic: font_path
       }
    )
    pdf.font "DejaVu"

    pdf.text "MONITORAMENTO DO DIA #{format_date(@sheet.monitoring_date)}",
             size: 14, style: :bold, align: :center

    pdf.move_down 20
    build_info_table(pdf)
    pdf.move_down 20
    build_photos_section(pdf)

    pdf.render
  end

  private

  def build_info_table(pdf)
    pdf.table([
      [ "Atividade", @sheet.activity.to_s ],
      [ "Intervalo de Estacas", @sheet.stake_interval.to_s ],
      [ "Lote", @sheet.lot.to_s ],
      [ "Coordenadas", "E=#{@sheet.start_x}; N=#{@sheet.start_y} - E=#{@sheet.end_x}; N=#{@sheet.end_y}" ],
      [ "Status da Obra", @sheet.work_status.to_s ],
      [ "Ocorrência", @sheet.occurrence_evaluation.to_s ]
    ], width: 500)
  end

  def build_photos_section(pdf)
    photos = @sheet.photos.includes(image_attachment: :blob)
    return if photos.empty?

    pdf.text "REGISTRO FOTOGRÁICO", size: 11, style: :bold
    pdf.move_down 10

    photos.each do |photo|
      pdf.text photo.caption.to_s, style: :bold, size: 9
      pdf.text "E=#{photo.coord_e}; N=#{photo.coord_e}", size: 8
      pdf.move_down 8
    end
  end

  def format_date(date)
    return "" unless date
    date.strftime("%d/%m/%Y")
  end
end
