require "spec_helper"

RSpec.describe Metanorma::Requirements do
  it "has a version number" do
    expect(Metanorma::Requirements::VERSION).not_to be nil
  end

  it "initialises class" do
    conv = IsoDoc::PresentationXMLConvert
      .new({
             output_formats: Metanorma::Standoc::Processor.new
             .output_formats,
           })
    expect(Metanorma::Requirements
      .new(default: "default", conv: conv)
      .model_names).to eq(%i[default ogc])
  end
end
