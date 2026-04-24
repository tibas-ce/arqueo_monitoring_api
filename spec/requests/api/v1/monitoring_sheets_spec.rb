require "rails_helper"

RSpec.describe "API::V1::MonitoringSheets", type: :request do
  let(:sheet) { create(:monitoring_sheet) }
  describe "GET /api/v1/monitoring_sheets" do
    it_behaves_like "um recurso paginado", "/api/v1/monitoring_sheets"
    it "retorna a lista de fichas" do
      create(:monitoring_sheet)

      get "/api/v1/monitoring_sheets"

      expect(response).to have_http_status(:ok)
      expect(json["data"].size).to be >= 1
    end
  end

  describe "GET /api/v1/monitoring_sheets/:id" do
    it "retorna ficha com dados válidos" do
      get "/api/v1/monitoring_sheets/#{sheet.id}"

      expect(response).to have_http_status(:ok)
      expect(json["data"]["attributes"]["lot"]).to eq("03")
    end

    it "retorna 404 quando ficha não existe" do
      get "/api/v1/monitoring_sheets/id-invalido"

      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to eq("Ficha não encontrada!")
    end
  end

  describe "GET /api/v1/monitoring_sheets/:id/export_pdf" do
    it "retorna um PDF" do
      get "/api/v1/monitoring_sheets/#{sheet.id}/export_pdf"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/pdf")
    end
  end

  describe "GET /api/v1/monitoring_sheets/filters" do
    context "filtra por lote" do
      it "filtra fichas por lote" do
        create(:monitoring_sheet, lot: "01")
        create(:monitoring_sheet, lot: "02")
        create(:monitoring_sheet, lot: "02")

        get "/api/v1/monitoring_sheets?lot=02"

        expect(response).to have_http_status(:ok)
        lots = json["data"].map { |s| s["attributes"]["lot"] }
        expect(lots.length).to eq(2)
        expect(lots.uniq).to eq([ "02" ])
      end

      it "retorna lista vazia quando nenhuma ficha corresponde ao lote" do
        create(:monitoring_sheet, lot: "01")

        get "/api/v1/monitoring_sheets?lot=99"

        expect(response).to have_http_status(:ok)
        expect(json["data"]).to be_empty
      end
    end

    context "filtra por intervalo de datas" do
       it "filtra fichas dentro do intervalo" do
        create(:monitoring_sheet, monitoring_date: "2025-01-10")
        create(:monitoring_sheet, monitoring_date: "2025-06-15")
        create(:monitoring_sheet, monitoring_date: "2025-12-20")

        get "/api/v1/monitoring_sheets?start_date=2025-01-01&end_date=2025-06-30"

        expect(response).to have_http_status(:ok)
        dates = json["data"].map { |s| Date.parse(s["attributes"]["monitoring_date"]) }
        expect(dates.length).to eq(2)
        expect(dates).to all(
          satisfy { |d| d >= Date.parse("2025-01-01") && d <= Date.parse("2025-06-30") }
        )
      end

      it "filtra fichas por data exata (start_date = end_date)" do
        create(:monitoring_sheet, monitoring_date: "2025-06-15")
        create(:monitoring_sheet, monitoring_date: "2025-07-01")

        get "/api/v1/monitoring_sheets?start_date=2025-06-15&end_date=2025-06-15"

        expect(response).to have_http_status(:ok)
        dates = json["data"].map { |s| Date.parse(s["attributes"]["monitoring_date"]) }
        expect(dates.length).to eq(1)
        expect(dates).to all(eq(Date.parse("2025-06-15")))
      end
    end

    context "combinar filtros" do
      it "combina filtro de lote e data" do
        create(:monitoring_sheet, lot: "02", monitoring_date: "2025-03-10")
        create(:monitoring_sheet, lot: "02", monitoring_date: "2025-08-10")
        create(:monitoring_sheet, lot: "03", monitoring_date: "2025-03-10")

        get "/api/v1/monitoring_sheets?lot=02&start_date=2025-01-01&end_date=2025-06-30"

        expect(response).to have_http_status(:ok)
        data = json["data"]
        expect(data.length).to eq(1)
        record = data.first["attributes"]
        expect(record["lot"]).to eq("02")
        expect(Date.parse(record["monitoring_date"])).to be_between(Date.parse("2025-01-01"), Date.parse("2025-06-30"))
      end

      it "retorna todas as fichas quando nenhum filtro é enviado" do
        create_list(:monitoring_sheet, 3)

        get "/api/v1/monitoring_sheets"

        expect(response).to have_http_status(:ok)
        expect(json["data"].length).to eq(3)
      end
    end

    context "parâmetros inválidos" do
      it "retorna error com dados inválidos" do
        create(:monitoring_sheet, monitoring_date: "2025-06-15")

        get "/api/v1/monitoring_sheets?start_date=invalid&end_date=invalid"

        expect(response).to have_http_status(:ok)
        expect(json["data"]).to be_an(Array)
      end
    end
  end

  describe "GET /api/v1/monitoring_sheets/pagination" do
    context "paginação padrão" do
      it "retorna dados paginados com metadados" do
        create_list(:monitoring_sheet, 12)

        get "/api/v1/monitoring_sheets"

        expect(response).to have_http_status(:ok)

        expect(json["data"].size).to eq(10)

        expect(json["meta"]).to include(
          "current_page" => 1,
          "total_count" => 12,
          "total_pages" => 2,
          "limit" => 10
        )
      end

      it "retorna registros ordenados por id" do
        create_list(:monitoring_sheet, 12)

        get "/api/v1/monitoring_sheets"

        ids = json["data"].map { |s| s["id"] }
        expected_ids = MonitoringSheet.order(:id).limit(10).pluck(:id)
        expect(ids).to eq(expected_ids)
      end
    end

    context "navegação entre páginas" do
      it "retorna a segunda página corretamente" do
        create_list(:monitoring_sheet, 12)

        get "/api/v1/monitoring_sheets?page=2"

        returned_ids = json["data"].map { |s| s["id"] }
        expected_ids = MonitoringSheet.order(:id).offset(10).limit(10).pluck(:id)

        expect(response).to have_http_status(:ok)
        expect(returned_ids.size).to eq(2)
        expect(returned_ids).to eq(expected_ids)
      end

      it "retorna conjuntos diferentes entre páginas" do
        create_list(:monitoring_sheet, 20)

        get "/api/v1/monitoring_sheets?page=1"
        page1_ids = json["data"].map { |s| s["id"] }

        get "/api/v1/monitoring_sheets?page=2"
        page2_ids = json["data"].map { |s| s["id"] }

        expect(page1_ids).not_to eq(page2_ids)
      end

      it "retorna lista vazia para página inexistente" do
        create_list(:monitoring_sheet, 5)

        get "/api/v1/monitoring_sheets?page=999"

        expect(response).to have_http_status(:ok)
        expect(json["data"]).to be_empty
        expect(json["meta"]["current_page"]).to eq(999)
        expect(json["meta"]["total_pages"]).to eq(1)
      end
    end

    context "customização de limites" do
      it "permite customizar o limite por página" do
        create_list(:monitoring_sheet, 12)

        get "/api/v1/monitoring_sheets?limit=5"

        expect(response).to have_http_status(:ok)
        expect(json["data"].length).to eq(5)
        expect(json["meta"]["limit"]).to eq(5)
      end
    end

    context "paginação com filtros" do
      it "respeita filtro de lote com paginação" do
        create_list(:monitoring_sheet, 8, lot: "02")
        create_list(:monitoring_sheet, 5, lot: "03")

        get "/api/v1/monitoring_sheets?lot=02&page=1"

        expect(response).to have_http_status(:ok)
        lots = json["data"].map { |s| s["attributes"]["lot"] }
        expect(lots).to all(eq("02"))
        expect(json["meta"]["total_count"]).to eq(8)
      end
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

      json_request(:post, "/api/v1/monitoring_sheets",  params: params)

      expect(response).to have_http_status(:created)
      expect(json["data"]["attributes"]["lot"]).to eq("03")
    end

    it "retorna erro com dados inválidos" do
      json_request(:post, "/api/v1/monitoring_sheets", params: { monitoring_sheet: { lot: "" } })

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/monitoring_sheets/:id" do
    it "usuário pode alterar atividade" do
      json_request(:patch, "/api/v1/monitoring_sheets/#{sheet.id}", params: { monitoring_sheet: { activity: "Supressão vegetal" } })

      expect(response).to have_http_status(:ok)
      expect(json["data"]["attributes"]["activity"]).to eq("Supressão vegetal")
    end
  end

  describe "DELETE /api/v1/monitoring_sheets/:id" do
    it "deleta ficha" do
       delete "/api/v1/monitoring_sheets/#{sheet.id}"

      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
    end
  end
end
