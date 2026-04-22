# Limpa na ordem correta para evitar erro de FK
Photo.destroy_all
MonitoringSheet.destroy_all
Project.destroy_all
Company.destroy_all

# Empresa
company = Company.create!(
  name:  "ArqueoCacos Consultoria Ltda",
  cnpj:  "12.345.678/0001-99",
  email: "contato@arqueocacos.com",
  phone: "(88) 98599-1213"
)

# Projeto
project = Project.create!(
  name:             "Monitoramento Arqueológico CE-060",
  description:      "Monitoramento arqueológico preventivo da rodovia CE-060 trecho Crato–Juazeiro",
  ordinance_number: "001/2026",
  municipality:     "Crato",
  company:          company
)

# Ficha
sheet = MonitoringSheet.create!(
  project:              project,
  monitoring_date:      Date.today,
  activity:             "Monitoramento de supressão vegetal",
  stake_interval:       "Est. 10+00 a Est. 25+00",
  lot:                  "Lote 02",
  start_x:              453_210.50,
  start_y:              9_178_340.75,
  end_x:                453_890.25,
  end_y:                9_178_120.30,
  work_status:          "Em andamento",
  occurrence_evaluation: "Nenhuma ocorrência de material arqueológico identificada durante as atividades de monitoramento."
)

# Fotos de teste
[
  { caption: "Figura 01 – Em #{Date.today.strftime('%d/%m/%y')} – Monitoramento de supressão vegetal.",
    coord_e: 453210.50, coord_n: 9178340.75,
    file: "app/assets/images/test_photo01.jpg" },
  { caption: "Figura 02 – Em #{Date.today.strftime('%d/%m/%y')} – Monitoramento de supressão vegetal.",
    coord_e: 453890.25, coord_n: 9178120.30,
    file: "app/assets/images/test_photo02.jpg" }
].each do |attrs|
  photo = sheet.photos.create!(
    caption:  attrs[:caption],
    coord_e:  attrs[:coord_e],
    coord_n:  attrs[:coord_n],
    position: sheet.photos.count + 1
  )
  photo.image.attach(
    io:           File.open(Rails.root.join(attrs[:file])),
    filename:     File.basename(attrs[:file]),
    content_type: "image/jpeg"
  )
end

puts "Fotos criadas: #{sheet.photos.count}"

puts "Seed concluído — Company: #{company.name}, Project: #{project.name}, Sheet ID: #{sheet.id}"
