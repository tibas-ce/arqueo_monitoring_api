require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe "validações" do
    it "é valido com atributos corretos" do
      expect_valid_factory(:photo)
    end

    it "é inválido sem monitoring_sheet" do
      expect_invalid_without(:photo, :monitoring_sheet)
    end
  end

  describe "associações" do
    it "pertence a uma monitoting_sheet" do
      photo = build(:photo)
      expect(photo.monitoring_sheet).to be_a(MonitoringSheet)
    end

    it "é destruida quando a monitoring_sheet é destruida" do
      sheet = create(:monitoring_sheet)
      create(:photo, monitoring_sheet: sheet)

      expect { sheet.destroy }.to change(Photo, :count).by(-1)
    end
  end

  describe "anexos" do
    it "pode ter uma imagem anexada" do
      photo = build(:photo)

      photo.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test_photo01.jpg")),
        filename: "teste_photo01.jpg",
        content_type: "image/jpeg"
      )

      expect(photo.image).to be_attached
    end
  end
end
