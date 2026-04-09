require "rails_helper"

RSpec.describe "API::V1::Photos", type: :request do
  let(:sheet) { create(:monitoring_sheet) }
  describe "POST /api/v1/:monitoring_sheet_id/photos" do
    it "cria uma photo com dados válidos" do
      params = {
        photo: {
            caption:              "Figura 01 - Exploração de jazida",
            coord_e:              "458037",
            coord_n:              "9198130",
            position:             "0"
        },
        image: fixture_file_upload("spec/fixtures/files/test_photo01.jpg", "image/jpeg")
      }

      post "/api/v1/monitoring_sheets/#{sheet.id}/photos", params: params,
        headers: { "Content-Type" => "multipart/form-data" }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["data"]["attributes"]["caption"]).to eq("Figura 01 - Exploração de jazida")
    end

    it "retorna erro com dados inválidos" do
      post "/api/v1/monitoring_sheets/id-invalido/photos", params: { photo: { caption: "Foto" } }.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/:monitoring_sheets_id/photos/:id" do
    let(:photo) { Photo.create!(
      monitoring_sheet:     sheet,
      caption:              "Figura 01 - Exploração de jazida",
      coord_e:              "458037",
      coord_n:              "9198130",
      position:             "0"
    )}

    it "deleta photo" do
       delete "/api/v1/monitoring_sheets/#{sheet.id}/photos/#{photo.id}",
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:no_content)
    end
  end
end
