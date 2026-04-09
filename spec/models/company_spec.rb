require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { create(:company) }
  it "é valido com atributos corretos" do
    expect(company).to be_valid
  end

  it "é inválido sem nome" do
    company = Company.new(name: nil)
    expect(company).not_to be_valid
  end
end
