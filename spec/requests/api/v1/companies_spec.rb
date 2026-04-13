require "rails_helper"

RSpec.describe "API::V1::Companies", type: :request do
  let(:company) { create(:company) }
  describe "GET /api/v1/companies" do
    it "retorna a lista de empresas" do
      create_list(:company, 2)

      get "/api/v1/companies"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].size).to eq(2)
    end
  end

  describe "GET /api/v1/companies/:id" do
    it "retorna empresa com dados válidos" do
      get "/api/v1/companies/#{company.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["attributes"]["name"]).to eq(company.name)
    end

    it "retorna 404 quando empresa não existe" do
      get "/api/v1/companies/id-invalido"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end

  describe "POST /api/v1/companies" do
    it "cria uma empresa com dados válidos" do
      params = {
        company: {
          name: "ArqueoLíticos Ltda",
          cnpj: "12.345.678/0001-99",
          email: "contato@arqueocacos.com",
          phone: "(88) 98599-1213"
        }
      }

      post "/api/v1/companies", params: params.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["data"]["attributes"]["name"]).to eq("ArqueoLíticos Ltda")
    end

    it "retorna erro com dados inválidos" do
      post "/api/v1/companies", params: {
        company: { name: "" } }.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end
end
