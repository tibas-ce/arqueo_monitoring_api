require "rails_helper"

RSpec.describe "API::V1::Projects", type: :request do
  let(:project) { create(:project) }
  describe "GET /api/v1/projects" do
    it "retorna a lista de projetos" do
      create_list(:project, 2)

      get "/api/v1/projects"

      expect(response).to have_http_status(:ok)
      expect(json["data"].size).to eq(2)
      expect(json["data"].first).to include("attributes")
    end
  end

  describe "GET /api/v1/projects/:id" do
    it "retorna projeto com dados válidos" do
      get "/api/v1/projects/#{project.id}"

      expect(response).to have_http_status(:ok)
      expect(json["data"]).to include("attributes")
      expect(json["data"]["attributes"]).to include(
        "name" => project.name,
        "description" => project.description,
        "ordinance_number"  => project.ordinance_number,
        "municipality"  => project.municipality,
        "company_id"  => project.company_id
        )
    end

    it "retorna 404 quando projeto não existe" do
      get "/api/v1/projects/id-invalido"

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to be_present
    end
  end

  describe "POST /api/v1/projects" do
    it "cria um projeto com dados válidos" do
      company = create(:company)
      params = {
        project: {
          name: "Projeto de Monitoramento CE-083",
          description: "Monitoramento arqueológico da rodovia CE-083",
          ordinance_number: "001/2026",
          municipality: "Crato",
          company_id: company.id
        }
      }

      json_request(:post, "/api/v1/projects", params: params)

      expect(response).to have_http_status(:created)
      expect(json["data"]["attributes"]["name"]).to eq(params[:project][:name])
    end

    it "retorna erro com dados inválidos" do
      json_request(:post, "/api/v1/projects", params: {
        project: { name: "" } })

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to be_present
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    it "atualiza um projeto com dados válidos" do
      json_request(:patch, "/api/v1/projects/#{project.id}", params: {
        project: { name: "CE-083 Atualizado" }
      })

      expect(response).to have_http_status(:ok)
      expect(json["data"]["attributes"]).to include("name" => "CE-083 Atualizado")
    end

    it "retorna erro com dados inválidos" do
      json_request(:patch, "/api/v1/projects/#{project.id}", params: {
        project: { name: "" }
      })

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["errors"]).to be_present
    end

    it "retorna 404 quando projeto não existe" do
      json_request(:patch, "/api/v1/projects/id-invalido", params: {
        project: { name: "Qualquer" }
      })

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to be_present
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    it "remove um projeto existente" do
      delete "/api/v1/projects/#{project.id}"

      expect(response).to have_http_status(:no_content)
      expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "retorna 404 quando projeto não existe" do
      delete "/api/v1/projects/id-invalido"

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to be_present
    end
  end
end
