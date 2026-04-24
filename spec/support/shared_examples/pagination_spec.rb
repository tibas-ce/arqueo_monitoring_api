RSpec.shared_examples "um recurso paginado" do |url|
  let!(:records) { create_list(:monitoring_sheet, 25) }

  it "retorna apenas a quantidade limitada de registros" do
    get url, params: { page: 1 }

    expect(json["data"].size).to eq(10)
  end

  it "retorna os metadados de paginação corretamente"  do
    get url, params: { page: 1 }

    expect(json["meta"]).to include(
      "current_page" => 1,
      "total_pages" => 3,
      "total_count" => 25
    )
  end

  it "retornar a última página com a quantidade restante de registros" do
    get url, params: { page: 3 }

    expect(json["data"].size).to eq(5)
    expect(json["meta"]["current_page"]).to eq(3)
  end

  context "casos de borda da paginação" do
    it "trata page=0 como página 1" do
      create_list(:monitoring_sheet, 5)

      get url, params: { page: 0 }

      expect(json["meta"]["current_page"]).to eq(1)
    end

    it "trata page negativa como página 1" do
      create_list(:monitoring_sheet, 5)

      get url, params: { page: -3 }

      expect(json["meta"]["current_page"]).to eq(1)
    end

    it "retorna lista vazia para página acima do total" do
      create_list(:monitoring_sheet, 5)

      get url, params: { page: 999 }

      expect(json["data"]).to be_empty
    end

    it "permite definir limite de itens por página" do
      create_list(:monitoring_sheet, 20)

      get url, params: { limit: 5 }

      expect(json["data"].size).to eq(5)
      expect(json["meta"]["limit"]).to eq(5)
    end

    it "limita o máximo de itens por página" do
      create_list(:monitoring_sheet, 30)

      get url, params: { limit: 1000 }

      expect(json["data"].size).to eq(10)
      expect(json["meta"]["limit"]).to eq(10)
    end
  end
end
