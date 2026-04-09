require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create(:project) }
  it "é valido com atributos corretos" do
    expect(project).to be_valid
  end

  it "é inválido sem nome" do
    project = Project.new(name: nil)
    expect(project).not_to be_valid
  end

  it "é inválido sem município" do
    project = Project.new(municipality: nil)
    expect(project).not_to be_valid
  end

  it "é inválido sem Empresa" do
    project = Project.new(company: nil)
    expect(project).not_to be_valid
  end
end
