require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:sheet) { MonitoringSheet.create!(
      monitoring_date:       "2025-07-16",
      activity:              "Exploração de jazida",
      lot:                   "03",
      work_status:           "Fase Intermediária",
      occurrence_evaluation: "Sem ocorrência arqueológica"
    )}
  it "é valido com atributos corretos" do
    photo = Photo.new(
      monitoring_sheet:      sheet,
      caption:               "Exploração de jazida",
      coord_e:               "458037",
      coord_n:               "9198130",
      position:              "0"
    )

    expect(photo).to be_valid
  end

  it "é inválido sem monitoring_sheet" do
    photo = Photo.new(monitoring_sheet: nil)
    expect(photo).not_to be_valid
  end
end
