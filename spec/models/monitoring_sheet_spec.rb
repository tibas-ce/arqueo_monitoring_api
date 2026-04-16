require "rails_helper"

RSpec.describe MonitoringSheet, type: :model do
  describe "validações" do
    it "é valido com atributos corretos" do
      expect_valid_factory(:monitoring_sheet)
    end

    it "valida campos obrigatórios" do
      fields = [
        :monitoring_date, :activity, :stake_interval, :lot,
        :start_x, :start_y, :end_x, :end_y,
        :work_status, :occurrence_evaluation, :project
      ]

      fields.each do |field|
        expect_invalid_without(:monitoring_sheet, field)
      end
    end
  end

  describe "associações" do
    it "é inválido sem associação com projeto" do
      expect(build(:monitoring_sheet, project: nil)).not_to be_valid
    end

    it "está associado a um projeto válido" do
      sheet = create(:monitoring_sheet)
      expect(sheet.project).to be_a(Project)
    end

    it "permite acessar a empresa através do projeto" do
      sheet = create(:monitoring_sheet)
      expect(sheet.project.company).to be_a(Company)
    end

    it "remover fotos associadas ao ser destruido" do
      sheet = create(:monitoring_sheet)
      create_list(:photo, 2, monitoring_sheet: sheet)

      expect { sheet.destroy }.to change(Photo, :count).by(-2)
    end
  end

  describe "coordenadas" do
    it "define o sistema de coordenadas automaticamente" do
      sheet = build(:monitoring_sheet, coordinate_system: nil)
      sheet.valid?

      expect(sheet.coordinate_system).to eq(MonitoringSheet::COORDINATE_SYSTEM)
    end

    it "sobrescreve o sistema de coordenadas automaticamente" do
      sheet = build(:monitoring_sheet, coordinate_system: "ERRADO")
      sheet.valid?

      expect(sheet.coordinate_system).to eq(MonitoringSheet::COORDINATE_SYSTEM)
    end
  end
end
