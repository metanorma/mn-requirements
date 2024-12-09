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
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="_" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Recommendation</span>
                                <semx element="autonum" source="_">1</semx>
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
                       <p id="_">
                          I recommend
                          <em>1</em>
                          .
                       </p>
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
                       <p id="_">
                          I recommend
                          <em>2</em>
                          .
                       </p>
                       <br/>
                       <p id="_">
                          I recommend
                          <em>2a</em>
                          .
                       </p>
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
                       <p id="_">
                          I recommend
                          <em>3</em>
                          .
                       </p>
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
                       <p id="_">
                          I recommend
                          <em>4</em>
                          .
                       </p>
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
                       <p id="_">
                          I recommend
                          <em>5</em>
                          .
                       </p>
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
                       <p id="_">
                          I recommend
                          <em>6</em>
                          .
                       </p>
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
                       <p id="_">
                          I recommend
                          <em>7</em>
                          .
                       </p>
                       <br/>
                       <p id="_">
                          I recommend
                          <em>7a</em>
                          .
                       </p>
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
                       <p id="_">
                          I recommend
                          <em>8</em>
                          .
                       </p>
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
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes URIs in requirement components" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <preface><foreword id="A"><title>Preface</title>
        <recommendation model="ogc" id="_">
      <identifier>http://www.example1.com</identifier>
      <inherit>http://www.example2.com</inherit>
      <subject>http://www.example3.com</subject>
      <description><p id="_">I recommend <em>1</em>.</p>
              <classification>
          <tag>http://www.example4.com</tag>
          <value>http://www.example5.com</value>
        </classification>
      </description>
      <component class="test-purpose" id="A1"><p>TEST PURPOSE</p></component>
      <description><p id="_">http://www.example6.com</p></description>
      <component class="panda GHz express" id="A7"><p>PANDA PART</p></component>
      <description>http://www.example7.com</description>
      </recommendation>
      </foreword>
      </preface>
      </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
        <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="_" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Recommendation</span>
                                <semx element="autonum" source="_">1</semx>
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
                       <tt>http://www.example1.com</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Subject</th>
                    <td>
                       <link target="http://www.example3.com"/>
                    </td>
                 </tr>
                 <tr>
                    <th>Prerequisite</th>
                    <td>
                       <link target="http://www.example2.com"/>
                    </td>
                 </tr>
                 <tr>
                    <th>Statement</th>
                    <td>
                       <p id="_">
                          I recommend
                          <em>1</em>
                          .
                       </p>
                       <dl>
                          <dt>http://www.example4.com</dt>
                          <dd>http://www.example5.com</dd>
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
                    <th>Statement</th>
                    <td>
                       <p id="_">http://www.example6.com</p>
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
                       <link target="http://www.example7.com"/>
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
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
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
        <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Requirement</span>
                                <semx element="autonum" source="A1">1</semx>
                             </span>
                          </fmt-name>
                       </p>
                    </th>
                 </tr>
              </thead>
              <tbody>
                 <tr>
                    <th>Test method type</th>
                    <td>
                       <p id="_">Manual Inspection</p>
                    </td>
                 </tr>
                 <tr>
                    <th>Test method</th>
                    <td>
                       <p id="1">
                          <ol class="steps">
                             <li>
                                <p id="2">For each UML class defined or referenced in the Tunnel Package:</p>
                                <ol class="steps">
                                   <li>
                                      <p id="3">
                    Validate that the Implementation Specification contains a data
                    element which represents the same concept as that defined for
                    the UML class.
                  </p>
                                   </li>
                                   <li>
                                      <p id="4">
                    Validate that the data element has the same relationships with
                    other elements as those defined for the UML class. Validate that
                    those relationships have the same source, target, direction,
                    roles, and multiplicies as those documented in the Conceptual
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
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
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
        <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Requirement</span>
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
                       <tt>/ogc/recommendation/wfs/1</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Conformance test</th>
                    <td>
                       <span class="fmt-element-name">Conformance test</span>
                       <semx element="autonum" source="A2">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A2">/ogc/recommendation/wfs/2</xref>
                       </tt>
                    </td>
                 </tr>
              </tbody>
           </table>
           <table id="A2" type="recommendtest" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTestTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Conformance test</span>
                                <semx element="autonum" source="A2">1</semx>
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
                    <th>Requirement</th>
                    <td>
                       <span class="fmt-element-name">Requirement</span>
                       <semx element="autonum" source="A1">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A1">/ogc/recommendation/wfs/1</xref>
                       </tt>
                    </td>
                 </tr>
              </tbody>
           </table>
           <table id="A3" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Requirements class</span>
                                <semx element="autonum" source="A3">1</semx>
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
                       <tt>/ogc/recommendation/wfs/3</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Conformance class</th>
                    <td>
                       <span class="fmt-element-name">Conformance class</span>
                       <semx element="autonum" source="A4">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A4">/ogc/recommendation/wfs/4</xref>
                       </tt>
                    </td>
                 </tr>
              </tbody>
           </table>
           <table id="A4" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Conformance class</span>
                                <semx element="autonum" source="A4">1</semx>
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
                       <tt>/ogc/recommendation/wfs/4</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Requirements class</th>
                    <td>
                       <span class="fmt-element-name">Requirements class</span>
                       <semx element="autonum" source="A3">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A3">/ogc/recommendation/wfs/3</xref>
                       </tt>
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
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end
end
