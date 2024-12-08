require "spec_helper"

RSpec.describe Metanorma::Requirements::Modspec do
  it "processes id xrefs by default" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="class" keep-with-next="true" keep-lines-together="true">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <permission model="ogc" id="A2">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        <xref target="B1"/>
        </description>
      </permission>
      <permission model="ogc" id="B1">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        </description>
      </permission>
      <p>
      <xref target="A1"/>
      <xref target="B1"/>
      <xref target="A1" style="id"/>
      <xref target="B1" style="id"/>
      <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
      <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
      <xref target="A">/ogc/recommendation/wfs/2</xref>
      <xref target="A1">/ogc/recommendation/wfs/2</xref>
      <xref target="B1">/ogc/recommendation/wfs/10</xref>
      </p>
          </foreword></preface>
          </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <foreword id="A" displayorder="2">
          <title id="_">Preface</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Preface</semx>
             </span>
          </fmt-title>
          <table id="A1" keep-with-next="true" keep-lines-together="true" type="recommendclass" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                         </span>
                      </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/ogc/recommendation/wfs/2</tt>
                   </td>
                </tr>
                <tr>
                   <th>Normative statements</th>
                   <td>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>
                            <xref style="id" target="B1">/ogc/recommendation/wfs/10</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Requirement</span>
                         <semx element="autonum" source="A3">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A3">Requirement 1</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Recommendation</span>
                         <semx element="autonum" source="A4">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A4">Recommendation 1</xref>
                         </tt>
                      </span>
                   </td>
                </tr>
                <tr>
                   <th>Description</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                      <xref target="B1">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>/ogc/recommendation/wfs/10</tt>
                      </xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <table id="B1" type="recommend" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permission</span>
                            <semx element="autonum" source="B1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/ogc/recommendation/wfs/10</tt>
                   </td>
                </tr>
                <tr>
                   <th>Included in</th>
                   <td>
                      <span class="fmt-element-name">Permissions class</span>
                      <semx element="autonum" source="A1">1</semx>
                      :
                      <tt>
                         <xref style="id" target="A1">/ogc/recommendation/wfs/2</xref>
                      </tt>
                   </td>
                </tr>
                <tr>
                   <th>Statement</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <p>
             <xref target="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/2</tt>
             </xref>
             <xref target="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/10</tt>
             </xref>
             <xref target="A1" style="id">A1</xref>
             <xref target="B1" style="id">B1</xref>
             <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
             <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
             <xref target="A">/ogc/recommendation/wfs/2</xref>
             <xref target="A1">/ogc/recommendation/wfs/2</xref>
             <xref target="B1">/ogc/recommendation/wfs/10</xref>
          </p>
       </foreword>
    OUTPUT

    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes id xrefs with modspec base id prefix" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="class" keep-with-next="true" keep-lines-together="true">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <permission model="ogc" id="A2">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        <xref target="B1"/>
        </description>
      </permission>
      <permission model="ogc" id="B1">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        </description>
      </permission>
      <p>
      <xref target="A1"/>
      <xref target="B1"/>
      <xref target="A1" style="id"/>
      <xref target="B1" style="id"/>
      <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
      <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
      <xref target="A">/ogc/recommendation/wfs/2</xref>
      <xref target="A1">/ogc/recommendation/wfs/2</xref>
      <xref target="B1">/ogc/recommendation/wfs/10</xref>
      </p>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword id="A" displayorder="2">
          <title id="_">Preface</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Preface</semx>
             </span>
          </fmt-title>
          <table id="A1" keep-with-next="true" keep-lines-together="true" type="recommendclass" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/recommendation/wfs/2</tt>
                   </td>
                </tr>
                <tr>
                   <th>Normative statements</th>
                   <td>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>
                            <xref style="id" target="B1">/recommendation/wfs/10</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Requirement</span>
                         <semx element="autonum" source="A3">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A3">Requirement 1</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Recommendation</span>
                         <semx element="autonum" source="A4">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A4">Recommendation 1</xref>
                         </tt>
                      </span>
                   </td>
                </tr>
                <tr>
                   <th>Description</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/recommendation/wfs/2</xref>
                      <xref target="B1" style="id">/recommendation/wfs/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                      <xref target="B1">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>/recommendation/wfs/10</tt>
                      </xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <table id="B1" type="recommend" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permission</span>
                            <semx element="autonum" source="B1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/recommendation/wfs/10</tt>
                   </td>
                </tr>
                <tr>
                   <th>Included in</th>
                   <td>
                      <span class="fmt-element-name">Permissions class</span>
                      <semx element="autonum" source="A1">1</semx>
                      :
                      <tt>
                         <xref style="id" target="A1">/recommendation/wfs/2</xref>
                      </tt>
                   </td>
                </tr>
                <tr>
                   <th>Statement</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/recommendation/wfs/2</xref>
                      <xref target="B1" style="id">/recommendation/wfs/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <p>
             <xref target="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/2</tt>
             </xref>
             <xref target="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/10</tt>
             </xref>
             <xref target="A1" style="id">A1</xref>
             <xref target="B1" style="id">B1</xref>
             <xref target="A1" style="id">/recommendation/wfs/2</xref>
             <xref target="B1" style="id">/recommendation/wfs/10</xref>
             <xref target="A">/ogc/recommendation/wfs/2</xref>
             <xref target="A1">/ogc/recommendation/wfs/2</xref>
             <xref target="B1">/ogc/recommendation/wfs/10</xref>
          </p>
       </foreword>
    OUTPUT
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({ modspecidentifierbase: "/ogc" })
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes id xrefs with base id prefix per requirement" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="class" keep-with-next="true" keep-lines-together="true">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <classification><tag>identifier-base</tag><value>/ogc/recommendation/wfs</value></classification>
        <permission model="ogc" id="A2">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        <xref target="B1"/>
        </description>
      </permission>
      <permission model="ogc" id="B1">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        <classification><tag>identifier-base</tag><value>/ogc/recommendation</value></classification>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        </description>
      </permission>
      <p>
      <xref target="A1"/>
      <xref target="B1"/>
      <xref target="A1" style="id"/>
      <xref target="B1" style="id"/>
      <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
      <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
      <xref target="A">/ogc/recommendation/wfs/2</xref>
      <xref target="A1">/ogc/recommendation/wfs/2</xref>
      <xref target="B1">/ogc/recommendation/wfs/10</xref>
      </p>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword id="A" displayorder="2">
          <title id="_">Preface</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Preface</semx>
             </span>
          </fmt-title>
          <table id="A1" keep-with-next="true" keep-lines-together="true" type="recommendclass" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                         </span>
                      </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/2</tt>
                   </td>
                </tr>
                <tr>
                   <th>Normative statements</th>
                   <td>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>
                            <xref style="id" target="B1">/10</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Requirement</span>
                         <semx element="autonum" source="A3">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A3">Requirement 1</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Recommendation</span>
                         <semx element="autonum" source="A4">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A4">Recommendation 1</xref>
                         </tt>
                      </span>
                   </td>
                </tr>
                <tr>
                   <th>Description</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/2</xref>
                      <xref target="B1" style="id">/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                      <xref target="B1">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>/10</tt>
                      </xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <table id="B1" type="recommend" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permission</span>
                            <semx element="autonum" source="B1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/wfs/10</tt>
                   </td>
                </tr>
                <tr>
                   <th>Included in</th>
                   <td>
                      <span class="fmt-element-name">Permissions class</span>
                      <semx element="autonum" source="A1">1</semx>
                      :
                      <tt>
                         <xref style="id" target="A1">/wfs/2</xref>
                      </tt>
                   </td>
                </tr>
                <tr>
                   <th>Statement</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/wfs/2</xref>
                      <xref target="B1" style="id">/wfs/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <p>
             <xref target="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/2</tt>
             </xref>
             <xref target="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/10</tt>
             </xref>
             <xref target="A1" style="id">A1</xref>
             <xref target="B1" style="id">B1</xref>
             <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
             <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
             <xref target="A">/ogc/recommendation/wfs/2</xref>
             <xref target="A1">/ogc/recommendation/wfs/2</xref>
             <xref target="B1">/ogc/recommendation/wfs/10</xref>
          </p>
       </foreword>
    OUTPUT
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes id xrefs with base id prefix per requirement with inheritance" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="class" keep-with-next="true" keep-lines-together="true">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <classification><tag>identifier-base</tag><value>/ogc/recommendation/wfs</value></classification>
        <permission model="ogc" id="A2">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        <xref target="B1"/>
        </description>
      </permission>
      <permission model="ogc" id="B1">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        </description>
      </permission>
      <p>
      <xref target="A1"/>
      <xref target="B1"/>
      <xref target="A1" style="id"/>
      <xref target="B1" style="id"/>
      <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
      <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
      <xref target="A">/ogc/recommendation/wfs/2</xref>
      <xref target="A1">/ogc/recommendation/wfs/2</xref>
      <xref target="B1">/ogc/recommendation/wfs/10</xref>
      </p>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword id="A" displayorder="2">
          <title id="_">Preface</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Preface</semx>
             </span>
          </fmt-title>
          <table id="A1" keep-with-next="true" keep-lines-together="true" type="recommendclass" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/2</tt>
                   </td>
                </tr>
                <tr>
                   <th>Normative statements</th>
                   <td>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>
                            <xref style="id" target="B1">/10</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Requirement</span>
                         <semx element="autonum" source="A3">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A3">Requirement 1</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Recommendation</span>
                         <semx element="autonum" source="A4">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A4">Recommendation 1</xref>
                         </tt>
                      </span>
                   </td>
                </tr>
                <tr>
                   <th>Description</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/2</xref>
                      <xref target="B1" style="id">/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                      <xref target="B1">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>/10</tt>
                      </xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <table id="B1" type="recommend" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permission</span>
                            <semx element="autonum" source="B1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/10</tt>
                   </td>
                </tr>
                <tr>
                   <th>Included in</th>
                   <td>
                      <span class="fmt-element-name">Permissions class</span>
                      <semx element="autonum" source="A1">1</semx>
                      :
                      <tt>
                         <xref style="id" target="A1">/2</xref>
                      </tt>
                   </td>
                </tr>
                <tr>
                   <th>Statement</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/2</xref>
                      <xref target="B1" style="id">/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <p>
             <xref target="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/2</tt>
             </xref>
             <xref target="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/10</tt>
             </xref>
             <xref target="A1" style="id">A1</xref>
             <xref target="B1" style="id">B1</xref>
             <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
             <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
             <xref target="A">/ogc/recommendation/wfs/2</xref>
             <xref target="A1">/ogc/recommendation/wfs/2</xref>
             <xref target="B1">/ogc/recommendation/wfs/10</xref>
          </p>
       </foreword>
    OUTPUT
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes id xrefs with base id prefix per requirement with inheritance and modspec base id prefix" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="class" keep-with-next="true" keep-lines-together="true">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <classification><tag>identifier-base</tag><value>/ogc/recommendation/wfs</value></classification>
        <permission model="ogc" id="A2">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        <xref target="B1"/>
        </description>
      </permission>
      <permission model="ogc" id="B1">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        <description>
        <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
        <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
        <xref target="A1">/ogc/recommendation/wfs/2</xref>
        <xref target="B1">/ogc/recommendation/wfs/10</xref>
        </description>
      </permission>
      <p>
      <xref target="A1"/>
      <xref target="B1"/>
      <xref target="A1" style="id"/>
      <xref target="B1" style="id"/>
      <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
      <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
      <xref target="A">/ogc/recommendation/wfs/2</xref>
      <xref target="A1">/ogc/recommendation/wfs/2</xref>
      <xref target="B1">/ogc/recommendation/wfs/10</xref>
      </p>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword id="A" displayorder="2">
          <title id="_">Preface</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Preface</semx>
             </span>
          </fmt-title>
          <table id="A1" keep-with-next="true" keep-lines-together="true" type="recommendclass" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/2</tt>
                   </td>
                </tr>
                <tr>
                   <th>Normative statements</th>
                   <td>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>
                            <xref style="id" target="B1">/10</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Requirement</span>
                         <semx element="autonum" source="A3">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A3">Requirement 1</xref>
                         </tt>
                      </span>
                      <br/>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Recommendation</span>
                         <semx element="autonum" source="A4">1-1</semx>
                         :
                         <tt>
                            <xref style="id" target="A4">Recommendation 1</xref>
                         </tt>
                      </span>
                   </td>
                </tr>
                <tr>
                   <th>Description</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/2</xref>
                      <xref target="B1" style="id">/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                      <xref target="B1">
                         <span class="fmt-element-name">Permission</span>
                         <semx element="autonum" source="B1">1</semx>
                         :
                         <tt>/10</tt>
                      </xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <table id="B1" type="recommend" class="modspec">
             <thead>
                <tr>
                   <th scope="colgroup" colspan="2">
                      <p class="RecommendationTitle">
                       <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Permission</span>
                            <semx element="autonum" source="B1">1</semx>
                         </span>
                       </fmt-name>
                      </p>
                   </th>
                </tr>
             </thead>
             <tbody>
                <tr>
                   <th>Identifier</th>
                   <td>
                      <tt>/10</tt>
                   </td>
                </tr>
                <tr>
                   <th>Included in</th>
                   <td>
                      <span class="fmt-element-name">Permissions class</span>
                      <semx element="autonum" source="A1">1</semx>
                      :
                      <tt>
                         <xref style="id" target="A1">/2</xref>
                      </tt>
                   </td>
                </tr>
                <tr>
                   <th>Statement</th>
                   <td>
                      <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                      <xref target="A1" style="id">/2</xref>
                      <xref target="B1" style="id">/10</xref>
                      <xref target="A1">/ogc/recommendation/wfs/2</xref>
                      <xref target="B1">/ogc/recommendation/wfs/10</xref>
                   </td>
                </tr>
             </tbody>
          </table>
          <p>
             <xref target="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/2</tt>
             </xref>
             <xref target="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>/ogc/recommendation/wfs/10</tt>
             </xref>
             <xref target="A1" style="id">A1</xref>
             <xref target="B1" style="id">B1</xref>
             <xref target="A1" style="id">/recommendation/wfs/2</xref>
             <xref target="B1" style="id">/recommendation/wfs/10</xref>
             <xref target="A">/ogc/recommendation/wfs/2</xref>
             <xref target="A1">/ogc/recommendation/wfs/2</xref>
             <xref target="B1">/ogc/recommendation/wfs/10</xref>
          </p>
       </foreword>
    OUTPUT
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({ modspecidentifierbase: "/ogc" })
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end
end
