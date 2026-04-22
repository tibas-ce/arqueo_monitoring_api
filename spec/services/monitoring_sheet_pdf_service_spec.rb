require "rails_helper"

RSpec.describe MonitoringSheetPdfService, type: :service do
  let(:company) { create(:company) }
  let(:project) { create(:project, company: company) }
  let(:sheet) { create(:monitoring_sheet, project: project) }

  subject(:pdf_output) { described_class.new(sheet).generate }

  describe "#generate" do
    it "retorna um PDF válido" do
      expect(pdf_output[0..3]).to eq("%PDF")
    end

    it "gera sem erros com fotos" do
      create_list(:photo, 3, monitoring_sheet: sheet)
      expect { pdf_output }.not_to raise_error
    end

    it "gera sem erros sem fotos" do
      expect { pdf_output }.not_to raise_error
    end

    it "gera sem erros com imagem orbital ausente" do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with(MonitoringSheetPdfService::ORBITAL_IMAGE_PATH)
        .and_return(false)

      expect { pdf_output }.not_to raise_error
    end
  end
end
