class MonitoringSheetPdfService
  ORBITAL_IMAGE_PATH = Rails.root.join("app/assets/images/satelite_test.jpg").to_s

  PAGE_WIDTH = 595.28
  MARGIN = 36
  CONTENT_WIDTH = PAGE_WIDTH - (MARGIN * 2)
  PHOTO_WIDTH = (CONTENT_WIDTH - 8) / 2
  PHOTO_HEIGHT = 190

  def initialize(sheet)
    @sheet = sheet
    @project = sheet.project
    @company = sheet.project.company
  end

  def generate
    pdf = Prawn::Document.new(page_size: "A4", margin: MARGIN)
    setup_fonts(pdf)
    build_header(pdf)
    build_info_table(pdf)
    build_status_table(pdf)
    build_photos_table(pdf)
    build_orbital_table(pdf)
    pdf.render
  end

  private

  # Fontes
  def setup_fonts(pdf)
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
  end

  # Cabeçalho
  def build_header(pdf)
    pdf.text @company.name.upcase, size: 13, style: :bold, align: :center
    pdf.move_down 2
    pdf.text @project.name, size: 10, align: :center
    pdf.move_down 2
    pdf.text "Portaria nº #{@project.ordinance_number} · #{@project.municipality}",
             size: 9, align: :center, color: "555555"
    pdf.move_down 6
    pdf.stroke_horizontal_rule
    pdf.move_down 8
    pdf.text "MONITORAMENTO DO DIA #{format_date(@sheet.monitoring_date)}",
             size: 11, style: :bold, align: :center
    pdf.move_down 10
  end

  # Tabela de dados da atividade
  #
  # | ATIVIDADE | INTERVALO/LOTE | PONTO INICIAL     | PONTO FINAL      |
  # |           |                | X        | Y      | X       | Y      |
  # | valor     | valor          | start_x  | start_y| end_x   | end_y  |

  def build_info_table(pdf)
    half = (CONTENT_WIDTH - 120 - 110) / 4.0

    pdf.table(
      [
        # Linha 1 — cabeçalhos principais
        [
          { content: "ATIVIDADE AVERIGUADA",                     rowspan: 3, font_style: :bold, size: 7, valign: :center },
          { content: "INTERVALO DE ESTACAS\nLOTE: #{@sheet.lot}", rowspan: 3, font_style: :bold, size: 7, valign: :center },
          { content: "DELIMITAÇÃO DA ÁREA DE PESQUISA",           colspan: 4, font_style: :bold, size: 7, align: :center }
        ],
        # Linha 2 — Ponto Inicial / Ponto Final
        [
          { content: "PONTO INICIAL", colspan: 2, font_style: :bold, size: 7, align: :center },
          { content: "PONTO FINAL",   colspan: 2, font_style: :bold, size: 7, align: :center }
        ],
        # Linha 3 — X / Y / X / Y
        [
          { content: "X", font_style: :bold, size: 7, align: :center },
          { content: "Y", font_style: :bold, size: 7, align: :center },
          { content: "X", font_style: :bold, size: 7, align: :center },
          { content: "Y", font_style: :bold, size: 7, align: :center }
        ],
        # Linha 4 — dados
        [
          { content: @sheet.activity.to_s,       size: 8 },
          { content: @sheet.stake_interval.to_s, size: 8 },
          { content: fmt_coord(@sheet.start_x),  size: 8, align: :center },
          { content: fmt_coord(@sheet.start_y),  size: 8, align: :center },
          { content: fmt_coord(@sheet.end_x),    size: 8, align: :center },
          { content: fmt_coord(@sheet.end_y),    size: 8, align: :center }
        ]
      ],
      width: CONTENT_WIDTH,
      column_widths: [ 120, 110, half, half, half, half ]
    ) do |t|
      t.cells.borders      = %i[top bottom left right]
      t.cells.border_color = "AAAAAA"
      t.cells.padding      = [ 4, 5 ]
    end

    pdf.move_down 4
  end

  # Tabela de status e ocorrência
  def build_status_table(pdf)
    status_w = 150

    pdf.table(
      [
        [
          { content: "STATUS DA OBRA",   font_style: :bold, size: 7, width: status_w },
          { content: "OCORRÊNCIA / AVALIAÇÃO DOS IMPACTOS AO PATRIMÔNIO ARQUEOLÓGICO",
            font_style: :bold, size: 7 }
        ],
        [
          { content: @sheet.work_status.to_s, size: 8 },
          { content: @sheet.occurrence_evaluation.to_s, size: 8 }
        ]
      ],
      width: CONTENT_WIDTH,
      column_widths: [ status_w, CONTENT_WIDTH - status_w ]
    ) do |t|
      t.cells.borders      = %i[top bottom left right]
      t.cells.border_color = "AAAAAA"
      t.cells.padding      = [ 4, 5 ]
    end

    pdf.move_down 4
  end

  # Seção de fotos
  def build_photos_table(pdf)
    photos = @sheet.photos.order(:position).includes(image_attachment: :blob)

    # Título da seção — span completo
    title_row = [
      { content: "REGISTRO FOTOGRÁFICO – SISTEMA DE COORDENADAS: #{@sheet.coordinate_system}",
        colspan: 2, font_style: :bold, size: 7, align: :center }
    ]

    rows = [ title_row ]

    if photos.empty?
      rows << [
        { content: "Sem fotos registradas.", colspan: 2, size: 8, align: :center }
      ]
    else
      photos.each_slice(2) do |pair|
        # Linha de legendas (acima das fotos)
        caption_cells = pair.map do |photo|
          { content: photo.caption.to_s, font_style: :bold, size: 7, align: :center }
        end
        caption_cells << { content: "", size: 7 } if pair.size == 1
        rows << caption_cells

        # Linha de imagens
        image_cells = pair.map { |photo| build_image_cell(photo) }
        image_cells << { content: "", size: 8 } if pair.size == 1
        rows << image_cells

        # Linha de coordenadas (abaixo das fotos)
        coord_cells = pair.map do |photo|
          { content: "E=#{photo.coord_e}; N=#{photo.coord_n}", size: 7, align: :center, text_color: "555555" }
        end
        coord_cells << { content: "", size: 7 } if pair.size == 1
        rows << coord_cells
      end
    end

    pdf.table(rows, width: CONTENT_WIDTH,
              column_widths: [ PHOTO_WIDTH, CONTENT_WIDTH - PHOTO_WIDTH ]) do |t|
      t.cells.borders      = %i[top bottom left right]
      t.cells.border_color = "AAAAAA"
      t.cells.padding      = [ 4, 5 ]

      # altura fixa apenas nas linhas de imagem (linhas 2, 5, 8... índice 2, 5, 8)
      t.rows(image_row_indices(rows)).height = PHOTO_HEIGHT
    end

    pdf.move_down 4
  end

  def build_image_cell(photo)
    return { content: "[ sem imagem ]", size: 8, align: :center } unless photo.image.attached?

    tmp = Tempfile.new([ "photo", ".jpg" ])
    tmp.binmode
    tmp.write(photo.image.download)
    tmp.flush
    tmp.close

    { image: tmp.path,
      fit:   [ PHOTO_WIDTH - 10, PHOTO_HEIGHT - 10 ],
      position: :center, vposition: :center }
  rescue StandardError
    { content: "[ sem imagem ]", size: 8, align: :center }
  end

  def image_row_indices(rows)
    # As linhas de imagem são as de índice 2, 5, 8... (após title + caption + image ciclo de 3)
    indices = []
    i = 2
    while i < rows.size
      indices << i
      i += 3
    end
    indices
  end

  # Imagem orbital
  def build_orbital_table(pdf)
    image_cell = if File.exist?(ORBITAL_IMAGE_PATH)
      { image: ORBITAL_IMAGE_PATH,
        fit: [ CONTENT_WIDTH - 10, 240 ],
        position: :center, vposition: :center }
    else
      { content: "[ Imagem orbital não disponível ]", size: 9, align: :center, text_color: "888888" }
    end

    pdf.table(
      [
        [ { content: "Imagem orbital do trecho monitorado",
            font_style: :bold, size: 7, align: :center } ],
        [ image_cell ],
        [ { content: "PM: Ponto de Monitoramento – SISTEMA DE COORDENADAS: #{@sheet.coordinate_system}",
            size: 7, align: :center, text_color: "555555" } ]
      ],
      width: CONTENT_WIDTH
    ) do |t|
      t.cells.borders      = %i[top bottom left right]
      t.cells.border_color = "AAAAAA"
      t.cells.padding      = [ 4, 5 ]
      t.row(1).height = 250
    end
  end

  # Helpers

  def fmt_coord(val)
    val ? val.to_i.to_s : ""
  end

  def format_date(date)
    return "" unless date
    date.strftime("%d/%m/%Y")
  end
end
