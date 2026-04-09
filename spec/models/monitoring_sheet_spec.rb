require "rails_helper"

RSpec.describe MonitoringSheet, type: :model do
  let(:sheet) { create(:monitoring_sheet) }
  it "é valido com atributos corretos" do
    expect(sheet).to be_valid
  end

  it "é inválido sem data" do
    sheet = build(:monitoring_sheet, monitoring_date: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem atividade" do
    sheet = build(:monitoring_sheet, activity: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem intervalo de estaca" do
    sheet = build(:monitoring_sheet, stake_interval: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem lote" do
    sheet = build(:monitoring_sheet, lot: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem ponto inicial X" do
    sheet = build(:monitoring_sheet, start_x: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem ponto inicial Y" do
    sheet = build(:monitoring_sheet, start_y: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem ponto final X" do
    sheet = build(:monitoring_sheet, end_x: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem ponto final Y" do
    sheet = build(:monitoring_sheet, end_y: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem status da obra" do
    sheet = build(:monitoring_sheet, work_status: nil)
    expect(sheet).not_to be_valid
  end

  it "é inválido sem avaliação de ocorrência" do
    sheet = build(:monitoring_sheet, occurrence_evaluation: nil)
    expect(sheet).not_to be_valid
  end

  it "define o sistema de coordenadas automaticamente" do
    sheet = build(:monitoring_sheet, coordinate_system: nil)
    sheet.valid?
    expect(sheet.coordinate_system).to eq("UTM-SIRGAS2000-ZONA24S")
  end

  it "é inválido sem associação com projeto" do
    sheet = build(:monitoring_sheet, project: nil)
    expect(sheet).not_to be_valid
  end
end
