require "spec_helper"

RSpec.describe Metanorma::Requirements do
  it "has a version number" do
    expect(Metanorma::Requirements::VERSION).not_to be nil
  end

  it "initialises class" do
    expect(Metanorma::Requirements
      .new(default: "default")
      .model_names).to eq(%i[default ogc])
  end
end
