require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validações" do
    it "é valido com atributos corretos" do
      project = create(:project)
      expect(project).to be_valid
    end

    it "valida campos obrigatórios" do
      fields = [ :name, :ordinance_number, :municipality ]

      fields.each do |field|
        expect_invalid_without(:project, field)
      end
    end
  end

  describe "associações" do
    it "é inválido sem Empresa" do
      project = build(:project, company: nil)
      expect(project).not_to be_valid
    end

    it "pertence a uma empresa" do
      project = create(:project)
      expect(project.company).to be_a(Company)
    end

    it "aparece na lista de projetos da empresa" do
      company = create(:company)
      project = create(:project, company: company)

      expect(company.projects).to include(project)
    end
  end
  describe "integridade" do
    it "é inválido com empresa inexistente (validação do Rails)" do
      project = build(:project, company_id: 99999)

      expect(project).not_to be_valid
      expect(project.errors[:company]).to include("must exist")
    end
  end
end
