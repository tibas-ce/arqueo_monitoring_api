require "rails_helper"

RSpec.describe "API::V1::MonitoringSheets", type: :request do
  let(:sheet) { create(:monitoring_sheet) }
  describe "GET /api/v1/monitoring_sheets" do
    it "retorna a lista de fichas" do
      create(:monitoring_sheet)

      get "/api/v1/monitoring_sheets"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].length).to eq(1)
    end
  end

  describe "GET /api/v1/monitoring_sheets/:id" do
    it "retorna ficha com dados válidos" do
      get "/api/v1/monitoring_sheets/#{sheet.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["attributes"]["lot"]).to eq("03")
    end

    it "retorna 404 quando ficha não existe" do
      get "/api/v1/monitoring_sheets/id-invalido"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Ficha não encontrada!")
    end
  end

  describe "GET /api/v1/monitoring_sheets/:id/export_pdf" do
    it "retorna um PDF" do
      get "/api/v1/monitoring_sheets/#{sheet.id}/export_pdf"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/pdf")
    end
  end

  describe "POST /api/v1/monitoring_sheets" do
    it "cria uma ficha com dados válidos" do
      project = create(:project)
      params = {
        monitoring_sheet: {
          monitoring_date:       "2025-07-16",
          activity:              "Exploração de jazida",
          stake_interval:        "020+310 a 020+380",
          lot:                   "03",
          start_x:               "458046.0",
          start_y:               "9198147.0",
          end_x:                 "458037.0",
          end_y:                 "9198130.0",
          work_status:           "Fase Intermediária",
          occurrence_evaluation: "Sem ocorrência arqueológica",
          project_id: project.id
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
    it "usuário pode alterar atividade" do
      patch "/api/v1/monitoring_sheets/#{sheet.id}",
        params: { monitoring_sheet: { activity: "Supressão vegetal" } }.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["attributes"]["activity"]).to eq("Supressão vegetal")
    end
  end

  describe "DELETE /api/v1/monitoring_sheets/:id" do
    it "deleta ficha" do
       delete "/api/v1/monitoring_sheets/#{sheet.id}",
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:no_content)
    end
  end
end
