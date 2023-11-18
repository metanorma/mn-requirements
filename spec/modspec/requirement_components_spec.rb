require "spec_helper"

RSpec.describe Metanorma::Requirements::Modspec do
  it "processes requirement components" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <preface><foreword id="A"><title>Preface</title>
        <recommendation model="ogc" id="_">
      <identifier>/ogc/recommendation/wfs/2</identifier>
      <inherit>/ss/584/2015/level/1</inherit>
      <subject>user</subject>
      <description><p id="_">I recommend <em>1</em>.</p>
              <classification>
          <tag>scope</tag>
          <value>random</value>
        </classification>
        <classification>
          <tag>widgets</tag>
          <value>randomer</value>
        </classification>
      </description>
      <component class="test-purpose" id="A1"><p>TEST PURPOSE</p></component>
      <description><p id="_">I recommend <em>2</em>.</p></description>
      <component class="guidance" id="A7"><p>GUIDANCE #1</p></component>
      <description><p id="_">I recommend <em>2a</em>.</p></description>
      <component class="conditions" id="A2"><p>CONDITIONS</p></component>
      <description><p id="_">I recommend <em>3</em>.</p></description>
      <component class="part" id="A3"><p>FIRST PART</p></component>
      <description><p id="_">I recommend <em>4</em>.</p></description>
      <component class="part" id="A4"><p>SECOND PART</p></component>
      <description><p id="_">I recommend <em>5</em>.</p></description>
      <component class="test-method" id="A5"><p>TEST METHOD</p></component>
      <description><p id="_">I recommend <em>6</em>.</p></description>
      <component class="part" id="A6"><p>THIRD PART</p></component>
      <description><p id="_">I recommend <em>7</em>.</p></description>
      <component class="guidance" id="A8"><p>GUIDANCE #2</p></component>
      <description><p id="_">I recommend <em>7a</em>.</p></description>
      <component class="panda GHz express" id="A7"><p>PANDA PART</p></component>
      <description><p id="_">I recommend <em>8</em>.</p></description>
      </recommendation>
      </foreword>
      </preface>
      </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword id="A" displayorder="2">
        <title>Preface</title>
        <table id="_" class="modspec" type="recommend">
          <thead>
            <tr>
              <th scope="colgroup" colspan="2">
                <p class="RecommendationTitle">Recommendation 1</p>
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
              <th>Subject</th>
              <td>user</td>
            </tr>
            <tr>
              <th>Prerequisite</th>
              <td>/ss/584/2015/level/1</td>
            </tr>
            <tr>
              <th>Statement</th>
              <td>
                <p id="_">I recommend <em>1</em>.</p>
                          <dl>
            <dt>scope</dt>
            <dd>random</dd>
            <dt>widgets</dt>
            <dd>randomer</dd>
          </dl>
              </td>
            </tr>
            <tr id="A1">
              <th>Test purpose</th>
              <td>
                <p>TEST PURPOSE</p>
              </td>
            </tr>
            <tr>
              <th>Statements</th>
              <td>
                <p id="_">I recommend <em>2</em>.</p>
                <br/>
                <p id="_">I recommend <em>2a</em>.</p>
              </td>
            </tr>
            <tr id="A2">
              <th>Conditions</th>
              <td>
                <p>CONDITIONS</p>
              </td>
            </tr>
            <tr>
              <th>Statement</th>
              <td>
                <p id="_">I recommend <em>3</em>.</p>
              </td>
            </tr>
            <tr id="A3">
              <th>A</th>
              <td>
                <p>FIRST PART</p>
              </td>
            </tr>
            <tr>
              <th>Statement</th>
              <td>
                <p id="_">I recommend <em>4</em>.</p>
              </td>
            </tr>
            <tr id="A4">
              <th>B</th>
              <td>
                <p>SECOND PART</p>
              </td>
            </tr>
            <tr>
              <th>Statement</th>
              <td>
                <p id="_">I recommend <em>5</em>.</p>
              </td>
            </tr>
            <tr id="A5">
              <th>Test method</th>
              <td>
                <p>TEST METHOD</p>
              </td>
            </tr>
            <tr>
              <th>Statement</th>
              <td>
                <p id="_">I recommend <em>6</em>.</p>
              </td>
            </tr>
            <tr id="A6">
              <th>C</th>
              <td>
                <p>THIRD PART</p>
              </td>
            </tr>
            <tr>
              <th>Statements</th>
              <td>
                <p id="_">I recommend <em>7</em>.</p>
                <br/>
                <p id="_">I recommend <em>7a</em>.</p>
              </td>
            </tr>
            <tr id="A7">
              <th>Panda GHz express</th>
              <td>
                <p>PANDA PART</p>
              </td>
            </tr>
            <tr>
              <th>Statement</th>
              <td>
                <p id="_">I recommend <em>8</em>.</p>
              </td>
            </tr>
            <tr id="A7">
              <th>Guidance</th>
              <td>
                <p>GUIDANCE #1</p>
                <br/>
                <p>GUIDANCE #2</p>
              </td>
            </tr>
          </tbody>
        </table>
      </foreword>
    OUTPUT

    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(xmlpp(out.to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes nested requirement steps" do
    input = <<~INPUT
                <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface>
                <foreword id="A"><title>Preface</title>
                    <requirement model="ogc" id='A1'>
        <component exclude='false' class='test method type'>
          <p id='_'>Manual Inspection</p>
        </component>
        <component exclude='false' class='test-method'>
          <p id='1'>
            <component exclude='false' class='step'>
              <p id='2'>For each UML class defined or referenced in the Tunnel Package:</p>
              <component exclude='false' class='step'>
                <p id='3'>
                  Validate that the Implementation Specification contains a data
                  element which represents the same concept as that defined for
                  the UML class.
                </p>
              </component>
              <component exclude='false' class='step'>
                <p id='4'>
                  Validate that the data element has the same relationships with
                  other elements as those defined for the UML class. Validate that
                  those relationships have the same source, target, direction,
                  roles, and multiplicies as those documented in the Conceptual
                  Model.
                </p>
              </component>
            </component>
          </p>
        </component>
      </requirement>
            </foreword></preface>
            </ogc-standard>
    INPUT
    presxml = <<~PRESXML
      <foreword id='A' displayorder='2'>
        <title>Preface</title>
        <table id='A1' class='modspec' type='recommend'>
          <thead>
            <tr>
              <th scope='colgroup' colspan='2'>
                <p class='RecommendationTitle'>Requirement 1</p>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>Test method type</th>
              <td>
                <p id='_'>Manual Inspection</p>
              </td>
            </tr>
            <tr>
              <th>Test method</th>
              <td>
                <p id='1'>
                  <ol class="steps">
                    <li>
                      <p id='2'>For each UML class defined or referenced in the Tunnel Package:</p>
                      <ol class="steps">
                        <li>
                          <p id='3'>
                             Validate that the Implementation Specification
                            contains a data element which represents the same
                            concept as that defined for the UML class.
                          </p>
                        </li>
                        <li>
                          <p id='4'>
                             Validate that the data element has the same
                            relationships with other elements as those defined for
                            the UML class. Validate that those relationships have
                            the same source, target, direction, roles, and
                            multiplicies as those documented in the Conceptual
                            Model.
                          </p>
                        </li>
                      </ol>
                    </li>
                  </ol>
                </p>
              </td>
            </tr>
          </tbody>
        </table>
      </foreword>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(xmlpp(out.to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes bidirectional requirement/conformance tests" do
    input = <<~INPUT
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <preface>
          <foreword id="A"><title>Preface</title>
              <requirement model="ogc" id='A1' type="general">
              <identifier>/ogc/recommendation/wfs/1</identifier>
              </requirement>
              <requirement model="ogc" id='A2' type="verification">
              <identifier>/ogc/recommendation/wfs/2</identifier>
              <classification><tag>target</tag><value>/ogc/recommendation/wfs/1</value></classification>
              </requirement>
              <requirement model="ogc" id='A3' type="class">
              <identifier>/ogc/recommendation/wfs/3</identifier>
              </requirement>
              <requirement model="ogc" id='A4' type="conformanceclass">
              <identifier>/ogc/recommendation/wfs/4</identifier>
              <classification><tag>target</tag><value>/ogc/recommendation/wfs/3</value></classification>
              </requirement>
      </foreword></preface>
      </ogc-standard>
    INPUT
    presxml = <<~PRESXML
      <foreword id='A' displayorder='2'>
        <title>Preface</title>
        <table id='A1' class='modspec' type='recommend'>
          <thead>
            <tr>
              <th scope='colgroup' colspan='2'>
                <p class='RecommendationTitle'>Requirement 1</p>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
            <th>Identifier</th>
              <td><tt>/ogc/recommendation/wfs/1</tt></td>
            </tr>
            <tr>
              <th>Conformance test</th>
              <td>
                <xref target='A2'>
                  Conformance test 1:
                  <tt>/ogc/recommendation/wfs/2</tt>
                </xref>
              </td>
            </tr>
          </tbody>
        </table>
        <table id='A2' class='modspec' type='recommendtest'>
          <thead>
            <tr>
              <th scope='colgroup' colspan='2'>
                <p class='RecommendationTestTitle'>Conformance test 1</p>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
            <th>Identifier</th><td><tt>/ogc/recommendation/wfs/2</tt></td>
            </tr>
            <tr>
              <th>Requirement</th>
              <td>
                <xref target='A1'>Requirement 1: <tt>/ogc/recommendation/wfs/1</tt></xref>
              </td>
            </tr>
          </tbody>
        </table>
        <table id='A3' class='modspec' type='recommendclass'>
          <thead>
            <tr>
              <th scope='colgroup' colspan='2'>
                <p class='RecommendationTitle'>Requirements class 1</p>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
            <th>Identifier</th>
              <td><tt>/ogc/recommendation/wfs/3</tt></td>
            </tr>
            <tr>
              <th>Conformance class</th>
              <td>
                <xref target='A4'>
                  Conformance class 1:
                  <tt>/ogc/recommendation/wfs/4</tt>
                </xref>
              </td>
            </tr>
          </tbody>
        </table>
        <table id='A4' class='modspec' type='recommendclass'>
          <thead>
            <tr>
              <th scope='colgroup' colspan='2'>
                <p class='RecommendationTitle'>Conformance class 1</p>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
            <th>Identifier</th>
              <td><tt>/ogc/recommendation/wfs/4</tt></td>
            </tr>
            <tr>
              <th>Requirements class</th>
              <td>
                <xref target='A3'>Requirements class 1: <tt>/ogc/recommendation/wfs/3</tt></xref>
              </td>
            </tr>
          </tbody>
        </table>
      </foreword>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(xmlpp(out.to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end
end
