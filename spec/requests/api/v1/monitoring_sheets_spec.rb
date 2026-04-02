require "rails_helper"

RSpec.describe "API::V1::MonitoringSheets", type: :request do
  describe "GET /api/v1/monitoring_sheets" do
    it "retorna a lista de fichas" do
      MonitoringSheet.create!(
        monitoring_date:       "2025-07-16",
        activity:              "Exploração de jazida",
        lot:                   "03",
        work_status:           "Fase Intermediária",
        occurrence_evaluation: "Sem ocorrência arqueológica"
      )

      get "/api/v1/monitoring_sheets"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].length).to eq(1)
    end
  end

  describe "GET /api/v1/monitoring_sheets/:id" do
    it "retorna ficha com dados válidos" do
      sheet = MonitoringSheet.create!(
          monitoring_date:       "2025-07-16",
          activity:              "Exploração de jazida",
          lot:                   "02",
          work_status:           "Fase Intermediária",
          occurrence_evaluation: "Sem ocorrência arqueológica"
        )

      get "/api/v1/monitoring_sheets/#{sheet.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["attributes"]["lot"]).to eq("02")
    end
  end

  describe "POST /api/v1/monitoring_sheets" do
    it "cria uma ficha com dados válidos" do
      params = {
        monitoring_sheet: {
          monitoring_date:       "2025-07-16",
          activity:              "Exploração de jazida",
          lot:                   "03",
          work_status:           "Fase Intermediária",
          occurrence_evaluation: "Sem ocorrência arqueológica"
        }
      }

      post "/api/v1/monitoring_sheets", params: params.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["data"]["attributes"]["lot"]).to eq("03")
    end

    it "retorna erro com dados inválidos" do
      post "/api/v1/monitoring_sheets", params: { monitoring_sheet: { lot: "" } }.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/monitoring_sheets/:id" do
    let(:sheet) { MonitoringSheet.create!(
      monitoring_date:       "2025-07-16",
      activity:              "Exploração de jazida",
      lot:                   "03",
      work_status:           "Fase Intermediária",
      occurrence_evaluation: "Sem ocorrência arqueológica"
    )}

    it "usuário pode alterar atividade" do
      patch "/api/v1/monitoring_sheets/#{sheet.id}",
        params: { monitoring_sheet: { activity: "Supressão vegetal" } }.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["attributes"]["activity"]).to eq("Supressão vegetal")
    end
  end

  describe "DELETE /api/v1/monitoring_sheets/:id" do
    let(:sheet) { MonitoringSheet.create!(
      monitoring_date:       "2025-07-16",
      activity:              "Exploração de jazida",
      lot:                   "03",
      work_status:           "Fase Intermediária",
      occurrence_evaluation: "Sem ocorrência arqueológica"
    )}

    it "deleta ficha" do
       delete "/api/v1/monitoring_sheets/#{sheet.id}",
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:no_content)
    end
  end
end
