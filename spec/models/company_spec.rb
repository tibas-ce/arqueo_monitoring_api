require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "validações" do
    it "é valido com atributos corretos" do
      expect_valid_factory(:company)
    end

    it "é inválido sem nome" do
      expect_invalid_without(:company, :name)
    end
  end

  describe "associações" do
    it "pode ter vários projetos" do
      company = create(:company)
      projects= create_list(:project, 3, company: company)

      expect(company.projects).to match_array(projects)
    end

    it "retorna projetos associados corretamente" do
      company = create(:company)
      other_company = create(:company)

      create(:project, company: company)
      create(:project, company: other_company)

      expect(company.projects.count).to eq(1)
    end
  end
end
