require "rails_helper"

RSpec.describe "POST /api/v1/monitoring_sheets", type: :request do
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
    expect(JSON.parse(response.body))["data"]["attributes"]["lot"].to eq("03")
  end

  it "retorna erro com dados inválidos" do
    post "/api/v1/monitoring_sheets", params: { monitoring_sheet: { lot: "" } }.to_json,
      headers: { "Content-Type" => "application/json" }

    expect(response).to have_http_status(:unprocessable_entity)
  end
end
