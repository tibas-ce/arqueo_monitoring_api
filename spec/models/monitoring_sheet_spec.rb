require "rails_helper"

RSpec.describe MonitoringSheet, type: :model do
  it "é valido com atributos corretos" do
    sheet = MonitoringSheet.new(
      monitoring_date:       Date.today,
      activity:              "Exploração de jazida",
      lot:                   "03",
      work_status:           "Fase Intermediária",
      occurrence_evaluation: "Sem ocorrência arqueológica"
    )

    expect(sheet).to be_valid
  end

  it "é inválido sem data" do
    sheet = MonitoringSheet.new(monitoring_date: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem atividade" do
    sheet = MonitoringSheet.new(activity: nil)
    expect(sheet).not_to be_valid
  end
end
