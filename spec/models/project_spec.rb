require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create(:project) }
  it "é valido com atributos corretos" do
    expect(project).to be_valid
  end

  it "é inválido sem nome" do
    project = build(:project, name: nil)
    expect(project).not_to be_valid
  end

  it "é inválido sem portaria" do
    project = build(:project, ordinance_number: nil)
    expect(project).not_to be_valid
  end

  it "é inválido sem município" do
    project = build(:project, municipality: nil)
    expect(project).not_to be_valid
  end

  it "é inválido sem Empresa" do
    project = build(:project, company: nil)
    expect(project).not_to be_valid
  end
end
