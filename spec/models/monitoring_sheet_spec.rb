require "rails_helper"

RSpec.describe MonitoringSheet, type: :model do
  let(:sheet) { create(:monitoring_sheet) }
  it "é valido com atributos corretos" do
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
