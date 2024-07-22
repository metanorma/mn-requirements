require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "asciidoctor"
require "rspec/matchers"
require "equivalent-xml"
require "mn-requirements"
require "isodoc"
require "metanorma-standoc"
require "xml-c14n"

Dir[File.expand_path("./support/**/**/*.rb", __dir__)]
  .sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around :each do |example|
    example.run
  rescue SystemExit
    fail "Unexpected exit encountered"
  end
end

OPTIONS = [backend: :standoc, header_footer: true, agree_to_terms: true].freeze

ASCIIDOC_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:
  :no-isobib:
  :data-uri-image: false

HDR

BLANK_HDR = <<~"HDR".freeze
  <?xml version="1.0" encoding="UTF-8"?>
  <standard-document xmlns="https://www.metanorma.org/ns/standoc" version="#{Metanorma::Standoc::VERSION}" type="semantic">
  <bibdata type="standard">
  <title language="en" format="text/plain">Document title</title>
    <language>en</language>
    <script>Latn</script>
    <status><stage>published</stage></status>
    <copyright>
      <from>#{Time.new.year}</from>
    </copyright>
    <ext>
    <doctype>standard</doctype>
    </ext>
  </bibdata>
    <metanorma-extension>
      <presentation-metadata>
      <name>TOC Heading Levels</name>
      <value>2</value>
    </presentation-metadata>
    <presentation-metadata>
      <name>HTML TOC Heading Levels</name>
      <value>2</value>
    </presentation-metadata>
    <presentation-metadata>
      <name>DOC TOC Heading Levels</name>
      <value>2</value>
    </presentation-metadata>
    <presentation-metadata>
      <name>PDF TOC Heading Levels</name>
      <value>2</value>
    </presentation-metadata>
      </metanorma-extension>
HDR

def strip_guid(xml)
  xml.gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
    .gsub(%r{ schema-version=['"][^'"]+['"]}, "")
    .gsub(%r{<fetched>[^<]+</fetched>}, "<fetched/>")
end

def strip_src(xml)
  xml.gsub(/\ssrc="[^"]+"/, ' src="_"')
end

def examples_path(path)
  File.join(File.expand_path("./examples", __dir__), path)
end

def fixtures_path(path)
  File.join(File.expand_path("./fixtures", __dir__), path)
end

private

def get_xml(search, code, opts)
  c = code.gsub(%r{[/\s:-]}, "_").sub(%r{_+$}, "").downcase
  file = examples_path("#{[c, opts.keys.join('_')].join '_'}.xml")
  File.exist?(file) and return File.read(file)
  xml = search.call(code)&.first&.first&.to_xml nil, opts
  File.write file, xml
  xml
end

def mock_open_uri(code)
  expect(OpenURI).to receive(:open_uri).and_wrap_original do |m, *args|
    # expect(args[0]).to be_instance_of String
    file = examples_path("#{code.tr('-', '_')}.html")
    File.write file, m.call(*args).read unless File.exist? file
    File.read file, encoding: "utf-8"
  end.at_least :once
end

def xml_string_conent(xml)
  strip_guid(Nokogiri::HTML(xml).to_s)
end
