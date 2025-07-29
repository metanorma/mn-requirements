require "spec_helper"

RSpec.describe Metanorma::Requirements::Default do
  it "cross-references requirements" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="N3"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <requirement id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="N3" model="default" class="Provision">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <requirement id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword displayorder="2" id="_">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="N1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="N2">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="N">2</semx>
                </fmt-xref>
             </semx>
             <xref target="N3" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N3">
                   <span class="fmt-element-name">Provision</span>
                   <semx element="autonum" source="N3">1</semx>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="note1">3</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="note2">4</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="Anote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references requirements in French" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <bibdata><language>fr</language></bibdata>
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <requirement id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <requirement id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword displayorder="2" id="_">
          <title id="_">Avant-propos</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Avant-propos</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="N1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="N2">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="N">2</semx>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="note1">3</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="note2">4</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="Anote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-element-name">Exigence</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references recommendations" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <recommendation id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <clause id="xyz"><title>Preparatory</title>
          <recommendation id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <recommendation id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <recommendation id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <recommendation id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          <clause id="annex1b">
          <recommendation id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword displayorder="2" id="_">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="N1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="N2">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="N">2</semx>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="note1">3</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="note2">4</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="Anote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "cross-references permissions" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <permission id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <clause id="xyz"><title>Preparatory</title>
          <permission id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <permission id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <permission id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <permission id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex1b">
          <permission id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword displayorder="2" id="_">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="N1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="N2">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="N">2</semx>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="note1">3</semx>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="note2">4</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="Anote1">(??)</semx>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="annex1">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="Anote2">2</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "labels and cross-references nested requirements" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
              <preface>
      <foreword>
      <p>
      <xref target="N1"/>
      <xref target="N2"/>
      <xref target="N"/>
      <xref target="Q1"/>
      <xref target="R1"/>
      <xref target="AN1"/>
      <xref target="AN2"/>
      <xref target="AN"/>
      <xref target="AQ1"/>
      <xref target="AR1"/>
      </p>
      </foreword>
      </preface>
      <sections>
      <clause id="xyz"><title>Preparatory</title>
      <permission id="N1" model="default">
      <permission id="N2" model="default">
      <permission id="N" model="default">
      </permission>
      </permission>
      <requirement id="Q1" model="default">
      </requirement>
      <recommendation id="R1" model="default">
      </recommendation>
      </permission>
      </clause>
      </sections>
      <annex id="Axyz"><title>Preparatory</title>
      <permission id="AN1" model="default">
      <permission id="AN2" model="default">
      <permission id="AN" model="default">
      </permission>
      </permission>
      <requirement id="AQ1" model="default">
      </requirement>
      <recommendation id="AR1" model="default">
      </recommendation>
      </permission>
      </annex>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
       <foreword displayorder="2" id="_">
          <title id="_">Foreword</title>
          <fmt-title id="_" depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="N1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="N1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N2">1</semx>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="N1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N2">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="N">1</semx>
                </fmt-xref>
             </semx>
             <xref target="Q1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Q1">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="N1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="Q1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="R1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="R1">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="N1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="R1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AN1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="Axyz">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AN2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN2">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="Axyz">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN2">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="Axyz">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN2">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AN">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AQ1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AQ1">
                   <span class="fmt-element-name">Requirement</span>
                   <semx element="autonum" source="Axyz">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AQ1">1</semx>
                </fmt-xref>
             </semx>
             <xref target="AR1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AR1">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="Axyz">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="AN1">1</semx>
                   <span class="fmt-autonum-delim">-</span>
                   <semx element="autonum" source="AR1">1</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Nokogiri.XML(IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end
end
