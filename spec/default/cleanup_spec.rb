require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Requirements::Default do
  it "moves requirement metadata deflist to correct location" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Clause

      [.requirement,subsequence="A",inherit="/ss/584/2015/level/1 &amp; /ss/584/2015/level/2"]
      ====
      [%metadata]
      model:: default
      render:: inline
      type:: class
      identifier:: http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules[*req/core*]
      subject:: Encoding of logical models
      inherit:: urn:iso:dis:iso:19156:clause:7.2.2
      inherit:: urn:iso:dis:iso:19156:clause:8
      inherit:: http://www.opengis.net/doc/IS/GML/3.2/clause/2.4
      inherit:: O&M Abstract model, OGC 10-004r3, clause D.3.4
      inherit:: http://www.opengis.net/spec/SWE/2.0/req/core/core-concepts-used
      inherit:: <<ref2>>
      inherit:: <<ref3>>
      target:: http://www.example.com
      classification:: priority:P0
      classification:: domain:Hydrology,Groundwater
      classification:: control-class:Technical
      obligation:: recommendation,requirement
      class:: provision

      I recommend this
      ====
    INPUT
    output = <<~OUTPUT
            #{BLANK_HDR}
            <sections>
        <clause id='_' inline-header='false' obligation='normative'>
          <title id="_">Clause</title>
          <requirement id='_' subsequence='A' obligation='recommendation,requirement' model='default' render='inline' type='class' class='provision'>
            <identifier>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</identifier>
            <subject>Encoding of logical models</subject>
            <inherit>/ss/584/2015/level/1 &amp; /ss/584/2015/level/2</inherit>
            <inherit>urn:iso:dis:iso:19156:clause:7.2.2</inherit>
            <inherit>urn:iso:dis:iso:19156:clause:8</inherit>
            <inherit>http://www.opengis.net/doc/IS/GML/3.2/clause/2.4</inherit>
            <inherit>O&amp;M Abstract model, OGC 10-004r3, clause D.3.4</inherit>
            <inherit>http://www.opengis.net/spec/SWE/2.0/req/core/core-concepts-used</inherit>
            <inherit>
              <xref target='ref2'/>
            </inherit>
            <inherit>
              <xref target='ref3'/>
            </inherit>
            <classification>
                 <tag>priority</tag>
                 <value>P0</value>
               </classification>
               <classification>
                 <tag>domain</tag>
                 <value>Hydrology</value>
               </classification>
               <classification>
                 <tag>domain</tag>
                 <value>Groundwater</value>
               </classification>
               <classification>
                 <tag>control-class</tag>
                 <value>Technical</value>
               </classification>
               <classification>
                 <tag>target</tag>
                 <value><link target='http://www.example.com'/></value>
               </classification>
            <description>
              <p id='_'>I recommend this</p>
            </description>
          </requirement>
        </clause>
      </sections>
            </metanorma>
    OUTPUT
    expect(strip_guid(Asciidoctor.convert(input, *OPTIONS)))
      .to be_xml_equivalent_to output
  end

  it "moves inherit macros to correct location" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Clause

      [.requirement,subsequence="A",inherit="/ss/584/2015/level/1 &amp; /ss/584/2015/level/2"]
      .Title
      ====
      inherit:[A]
      inherit:[B]
      I recommend this
      ====

      [.requirement,subsequence="A",classification="X:Y"]
      .Title
      ====
      inherit:[A]
      I recommend this
      ====

      [.requirement,subsequence="A"]
      .Title
      ====
      inherit:[A]
      I recommend this
      ====

      [.requirement,subsequence="A"]
      .Title
      ====
      inherit:[A]
      ====

      [.requirement,subsequence="A"]
      ====
      inherit:[A]
      ====

    INPUT
    output = <<~OUTPUT
        #{BLANK_HDR}
        <sections>
          <clause id='_' inline-header='false' obligation='normative'>
            <title id="_">Clause</title>
            <requirement id='_' subsequence='A' model="default">
                         <title>Title</title>
              <inherit>A</inherit>
              <inherit>B</inherit>
              <inherit>/ss/584/2015/level/1 &amp; /ss/584/2015/level/2</inherit>
              <description>
                <p id='_'> I recommend this</p>
              </description>
            </requirement>
            <requirement id='_' subsequence='A' model="default">
              <title>Title</title>
              <inherit>A</inherit>
              <classification>
                <tag>X</tag>
                <value>Y</value>
              </classification>
              <description>
                <p id='_'> I recommend this</p>
              </description>
            </requirement>
            <requirement id='_' subsequence='A' model="default">
              <title>Title</title>
              <inherit>A</inherit>
              <description>
                <p id='_'> I recommend this</p>
              </description>
            </requirement>
            <requirement id='_' subsequence='A' model="default">
              <title>Title</title>
                 <inherit>A</inherit>
              </requirement>
              <requirement id='_' subsequence='A' model="default">
              <inherit>A</inherit>
            </requirement>
          </clause>
        </sections>
      </metanorma>
    OUTPUT
    expect(strip_guid(Asciidoctor.convert(input, *OPTIONS)))
      .to be_xml_equivalent_to output
  end

  it "extends requirement dl syntax" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Clause

      [.requirement,subsequence="A",inherit="/ss/584/2015/level/1 &amp; /ss/584/2015/level/2"]
      ====
      [%metadata]
      model:: default
      type:: class
      identifier:: http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules[*req/core*]
      widget:: producer
      gromit:: A
      +
      --
      * B
      * C
      * D
      --
      ====

    INPUT
    output = <<~OUTPUT
        #{BLANK_HDR}
           <sections>
             <clause id="_" inline-header="false" obligation="normative">
                <title id="_">Clause</title>
                <requirement id="_" subsequence="A" model="default" type="class">
                   <identifier>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</identifier>
                   <inherit>/ss/584/2015/level/1 &amp; /ss/584/2015/level/2</inherit>
                   <classification>
                      <tag>widget</tag>
                      <value>producer</value>
                   </classification>
                   <classification>
                      <tag>gromit</tag>
                      <value>
                         <p id="_">A</p>
                         <ul id="_">
                            <li>
                               <p id="_">B</p>
                            </li>
                            <li>
                               <p id="_">C</p>
                            </li>
                            <li>
                               <p id="_">D</p>
                            </li>
                         </ul>
                      </value>
                   </classification>
                </requirement>
             </clause>
          </sections>
      </metanorma>
    OUTPUT
    expect(strip_guid(Asciidoctor.convert(input, *OPTIONS)))
      .to be_xml_equivalent_to output
  end

  # metanorma/metanorma-standoc#1239: the provisions model fixes the metadata
  # head order (title?, identifier?, subject*, inherit*, classification*), but
  # requirement processing can emit subject after classification; reordering
  # restores the canonical sequence.
  describe "#requirement_metadata_reorder" do
    let(:model) { Class.new(described_class).allocate }

    def head(xml)
      reqt = Nokogiri::XML(xml).root
      model.requirement_metadata_reorder(reqt)
      reqt.elements.map(&:name)
    end

    it "reorders a classification emitted before subject into canonical order" do
      expect(head(<<~XML))
        <requirement>
          <title>T</title>
          <classification><tag>priority</tag><value>P0</value></classification>
          <subject>S</subject>
          <inherit>I</inherit>
          <description><p>body</p></description>
        </requirement>
      XML
        .to eq %w(title subject inherit classification description)
    end

    it "preserves order within each metadata type and keeps the body last" do
      reqt = Nokogiri::XML(<<~XML).root
        <requirement>
          <classification><value>c1</value></classification>
          <identifier>id</identifier>
          <classification><value>c2</value></classification>
          <subject>s1</subject>
          <title>T</title>
          <subject>s2</subject>
          <description><p>body</p></description>
        </requirement>
      XML
      model.requirement_metadata_reorder(reqt)
      expect(reqt.elements.map(&:name))
        .to eq %w(title identifier subject subject classification classification
                  description)
      expect(reqt.xpath("./subject").map(&:text)).to eq %w(s1 s2)
      expect(reqt.xpath("./classification/value").map(&:text)).to eq %w(c1 c2)
    end

    it "leaves an already-canonical head unchanged" do
      expect(head(<<~XML))
        <requirement>
          <title>T</title>
          <identifier>id</identifier>
          <subject>S</subject>
          <classification><value>c</value></classification>
        </requirement>
      XML
        .to eq %w(title identifier subject classification)
    end
  end
end
