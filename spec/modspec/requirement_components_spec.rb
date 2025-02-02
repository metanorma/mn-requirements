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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <recommendation model="ogc" autonum="1" original-id="_">
             <fmt-xref-label>
                <span class="fmt-element-name">Recommendation</span>
                <semx element="autonum" source="_">1</semx>
                :
                <tt>
                   <xref style="id" target="_">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/2</identifier>
             <inherit id="_">/ss/584/2015/level/1</inherit>
             <subject id="_">user</subject>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>1</em>
                   .
                </p>
                <classification>
                   <tag id="_">scope</tag>
                   <value id="_">random</value>
                </classification>
                <classification>
                   <tag id="_">widgets</tag>
                   <value id="_">randomer</value>
                </classification>
             </description>
             <component class="test-purpose" id="A1">
                <p>TEST PURPOSE</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>2</em>
                   .
                </p>
             </description>
             <component class="guidance" id="A7">
                <p>GUIDANCE #1</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>2a</em>
                   .
                </p>
             </description>
             <component class="conditions" id="A2">
                <p>CONDITIONS</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>3</em>
                   .
                </p>
             </description>
             <component class="part" id="A3">
                <p>FIRST PART</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>4</em>
                   .
                </p>
             </description>
             <component class="part" id="A4">
                <p>SECOND PART</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>5</em>
                   .
                </p>
             </description>
             <component class="test-method" id="A5">
                <p>TEST METHOD</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>6</em>
                   .
                </p>
             </description>
             <component class="part" id="A6">
                <p>THIRD PART</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>7</em>
                   .
                </p>
             </description>
             <component class="guidance" id="A8">
                <p>GUIDANCE #2</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>7a</em>
                   .
                </p>
             </description>
             <component class="panda GHz express" id="A7">
                <p>PANDA PART</p>
             </component>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>8</em>
                   .
                </p>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Subject</th>
                         <td>
                            <semx element="subject" source="_">user</semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Prerequisite</th>
                         <td>
                            <semx element="inherit" source="_">/ss/584/2015/level/1</semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>1</em>
                                  .
                               </p>
                               <dl>
                                  <dt>
                                     <semx element="tag" source="_">scope</semx>
                                  </dt>
                                  <dd>
                                     <semx element="value" source="_">random</semx>
                                  </dd>
                                  <dt>
                                     <semx element="tag" source="_">widgets</semx>
                                  </dt>
                                  <dd>
                                     <semx element="value" source="_">randomer</semx>
                                  </dd>
                               </dl>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A1">
                         <th>Test purpose</th>
                         <td>
                            <semx element="component" source="A1">
                               <p>TEST PURPOSE</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statements</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>2</em>
                                  .
                               </p>
                            </semx>
                            <br/>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>2a</em>
                                  .
                               </p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A2">
                         <th>Conditions</th>
                         <td>
                            <semx element="component" source="A2">
                               <p>CONDITIONS</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>3</em>
                                  .
                               </p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A3">
                         <th>A</th>
                         <td>
                            <semx element="component" source="A3">
                               <p>FIRST PART</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>4</em>
                                  .
                               </p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A4">
                         <th>B</th>
                         <td>
                            <semx element="component" source="A4">
                               <p>SECOND PART</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>5</em>
                                  .
                               </p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A5">
                         <th>Test method</th>
                         <td>
                            <semx element="component" source="A5">
                               <p>TEST METHOD</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>6</em>
                                  .
                               </p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A6">
                         <th>C</th>
                         <td>
                            <semx element="component" source="A6">
                               <p>THIRD PART</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statements</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>7</em>
                                  .
                               </p>
                            </semx>
                            <br/>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>7a</em>
                                  .
                               </p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A7">
                         <th>Panda GHz express</th>
                         <td>
                            <semx element="component" source="A7">
                               <p>PANDA PART</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>8</em>
                                  .
                               </p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A7">
                         <th>Guidance</th>
                         <td>
                            <semx element="component" source="A7">
                               <p>GUIDANCE #1</p>
                            </semx>
                            <br/>
                            <semx element="component" source="A8">
                               <p>GUIDANCE #2</p>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </recommendation>
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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <recommendation model="ogc" autonum="1" original-id="_">
             <fmt-xref-label>
                <span class="fmt-element-name">Recommendation</span>
                <semx element="autonum" source="_">1</semx>
                :
                <tt>
                   <xref style="id" target="_">
                      <semx element="identifier" source="_">http://www.example1.com</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">http://www.example1.com</identifier>
             <inherit id="_">http://www.example2.com</inherit>
             <subject id="_">http://www.example3.com</subject>
             <description id="_">
                <p original-id="_">
                   I recommend
                   <em>1</em>
                   .
                </p>
                <classification>
                   <tag id="_">http://www.example4.com</tag>
                   <value id="_">http://www.example5.com</value>
                </classification>
             </description>
             <component class="test-purpose" id="A1">
                <p>TEST PURPOSE</p>
             </component>
             <description id="_">
                <p original-id="_">http://www.example6.com</p>
             </description>
             <component class="panda GHz express" id="A7">
                <p>PANDA PART</p>
             </component>
             <description id="_">http://www.example7.com</description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">http://www.example1.com</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Subject</th>
                         <td>
                            <link target="http://www.example3.com">
                               <semx element="subject" source="_">http://www.example3.com</semx>
                            </link>
                         </td>
                      </tr>
                      <tr>
                         <th>Prerequisite</th>
                         <td>
                            <link target="http://www.example2.com">
                               <semx element="inherit" source="_">http://www.example2.com</semx>
                            </link>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <p id="_">
                                  I recommend
                                  <em>1</em>
                                  .
                               </p>
                               <dl>
                                  <dt>
                                     <semx element="tag" source="_">http://www.example4.com</semx>
                                  </dt>
                                  <dd>
                                     <semx element="value" source="_">http://www.example5.com</semx>
                                  </dd>
                               </dl>
                            </semx>
                         </td>
                      </tr>
                      <tr id="A1">
                         <th>Test purpose</th>
                         <td>
                            <semx element="component" source="A1">
                               <p>TEST PURPOSE</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <link target="http://www.example6.com">
                               <semx element="description" source="_">
                                  <p id="_">http://www.example6.com</p>
                               </semx>
                            </link>
                         </td>
                      </tr>
                      <tr id="A7">
                         <th>Panda GHz express</th>
                         <td>
                            <semx element="component" source="A7">
                               <p>PANDA PART</p>
                            </semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <link target="http://www.example7.com">
                               <semx element="description" source="_">http://www.example7.com</semx>
                            </link>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </recommendation>
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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <requirement model="ogc" original-id="A1" autonum="1">
             <fmt-xref-label>
                <span class="fmt-element-name">Requirement</span>
                <semx element="autonum" source="A1">1</semx>
             </fmt-xref-label>
             <component exclude="false" class="test method type" id="_">
                <p original-id="_">Manual Inspection</p>
             </component>
             <component exclude="false" class="test-method" id="_">
                <p original-id="1">
                   <component exclude="false" class="step">
                      <p original-id="2">For each UML class defined or referenced in the Tunnel Package:</p>
                      <component exclude="false" class="step">
                         <p original-id="3">
                   Validate that the Implementation Specification contains a data
                   element which represents the same concept as that defined for
                   the UML class.
                 </p>
                      </component>
                      <component exclude="false" class="step">
                         <p original-id="4">
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
             <fmt-provision>
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
                      <tr id="_">
                         <th>Test method type</th>
                         <td>
                            <semx element="component" source="_">
                               <p id="_">Manual Inspection</p>
                            </semx>
                         </td>
                      </tr>
                      <tr id="_">
                         <th>Test method</th>
                         <td>
                            <semx element="component" source="_">
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
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </requirement>
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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <requirement model="ogc" original-id="A1" type="general" autonum="1">
             <fmt-xref-label>
                <span class="fmt-element-name">Requirement</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/1</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/1</identifier>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/ogc/recommendation/wfs/1</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Conformance test</th>
                         <td>
                            <span class="fmt-element-name">Conformance test</span>
                            <semx element="autonum" source="A2">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A2">
                                  <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                               </xref>
                            </tt>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </requirement>
          <requirement model="ogc" original-id="A2" type="verification" autonum="1">
             <fmt-xref-label>
                <span class="fmt-element-name">Conformance test</span>
                <semx element="autonum" source="A2">1</semx>
                :
                <tt>
                   <xref style="id" target="A2">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/2</identifier>
             <classification>
                <tag>target</tag>
                <value id="_">/ogc/recommendation/wfs/1</value>
             </classification>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Requirement</th>
                         <td>
                            <span class="fmt-element-name">Requirement</span>
                            <semx element="autonum" source="A1">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A1">
                                  <semx element="identifier" source="_">/ogc/recommendation/wfs/1</semx>
                               </xref>
                            </tt>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </requirement>
          <requirement model="ogc" original-id="A3" type="class" autonum="1">
             <fmt-xref-label>
                <span class="fmt-element-name">Requirements class</span>
                <semx element="autonum" source="A3">1</semx>
                :
                <tt>
                   <xref style="id" target="A3">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/3</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/3</identifier>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/ogc/recommendation/wfs/3</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Conformance class</th>
                         <td>
                            <span class="fmt-element-name">Conformance class</span>
                            <semx element="autonum" source="A4">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A4">
                                  <semx element="identifier" source="_">/ogc/recommendation/wfs/4</semx>
                               </xref>
                            </tt>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </requirement>
          <requirement model="ogc" original-id="A4" type="conformanceclass" autonum="1">
             <fmt-xref-label>
                <span class="fmt-element-name">Conformance class</span>
                <semx element="autonum" source="A4">1</semx>
                :
                <tt>
                   <xref style="id" target="A4">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/4</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/4</identifier>
             <classification>
                <tag>target</tag>
                <value id="_">/ogc/recommendation/wfs/3</value>
             </classification>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/ogc/recommendation/wfs/4</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Requirements class</th>
                         <td>
                            <span class="fmt-element-name">Requirements class</span>
                            <semx element="autonum" source="A3">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A3">
                                  <semx element="identifier" source="_">/ogc/recommendation/wfs/3</semx>
                               </xref>
                            </tt>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </requirement>
       </foreword>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes nested requirement" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <preface><foreword id="A"><title>Preface</title>
        <requirement id="_c48cc925-b506-b047-d2b3-ed869fa42ebc" model="ogc" obligation="requirement" type="class"><subject>Software implementation</subject>
<inherit>http://www.opengis.net/spec/WPS/2.0/req/conceptual-model</inherit><inherit>OWS Common 2.0</inherit><inherit>http://www.opengis.net/spec/WPS/2.0/req/service/model/handling</inherit><requirement id="_60bc1828-5e99-25ad-4ef2-c24b3b14138a" model="ogc" type="general"> <description><p id="_fea70c5b-26ca-cfe3-fbd5-74c62ccf5d19"><em>GetStatus request shall comply with the structure defined in <xref target="fig-getstatus-request-uml"/> and <xref target="tab-addition-properties-in-the-getstatus-request"/>.</em></p></description>
</requirement>

<requirement id="_d12a3db5-4115-d12d-b7e1-d42009461672" model="ogc" type="general"> <description><p id="_cb6b025c-e032-5bf5-b838-3b44693e2891"><em>The JobID used in the request shall be a valid identifier which the client has received with the execute response.</em></p></description>
</requirement>
</requirement>
      </foreword>
      </preface>
      </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
           <foreword id="A" displayorder="2">
          <title id="_">Preface</title>
          <fmt-title depth="1">
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <requirement model="ogc" obligation="requirement" type="class" autonum="1" original-id="_">
             <fmt-xref-label>
                <span class="fmt-element-name">Requirements class</span>
                <semx element="autonum" source="_">1</semx>
             </fmt-xref-label>
             <subject id="_">Software implementation</subject>
             <inherit id="_">http://www.opengis.net/spec/WPS/2.0/req/conceptual-model</inherit>
             <inherit id="_">OWS Common 2.0</inherit>
             <inherit id="_">http://www.opengis.net/spec/WPS/2.0/req/service/model/handling</inherit>
             <requirement model="ogc" type="general" autonum="1-1" original-id="_" id="_">
                <description original-id="_">
                   <p original-id="_">
                      <em>
                         GetStatus request shall comply with the structure defined in
                         <xref target="fig-getstatus-request-uml"/>
                         and
                         <xref target="tab-addition-properties-in-the-getstatus-request"/>
                         .
                      </em>
                   </p>
                </description>
             </requirement>
             <requirement model="ogc" type="general" autonum="1-2" original-id="_" id="_">
                <description original-id="_">
                   <p original-id="_">
                      <em>The JobID used in the request shall be a valid identifier which the client has received with the execute response.</em>
                   </p>
                </description>
             </requirement>
             <fmt-provision>
                <table id="_" type="recommendclass" class="modspec">
                   <thead>
                      <tr>
                         <th scope="colgroup" colspan="2">
                            <p class="RecommendationTitle">
                               <fmt-name>
                                  <span class="fmt-caption-label">
                                     <span class="fmt-element-name">Requirements class</span>
                                     <semx element="autonum" source="_">1</semx>
                                  </span>
                               </fmt-name>
                            </p>
                         </th>
                      </tr>
                   </thead>
                   <tbody>
                      <tr>
                         <th>Obligation</th>
                         <td>requirement</td>
                      </tr>
                      <tr>
                         <th>Target type</th>
                         <td>
                            <semx element="subject" source="_">Software implementation</semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Prerequisites</th>
                         <td>
                            <semx element="inherit" source="_">http://www.opengis.net/spec/WPS/2.0/req/conceptual-model</semx>
                            <br/>
                            <semx element="inherit" source="_">OWS Common 2.0</semx>
                            <br/>
                            <semx element="inherit" source="_">http://www.opengis.net/spec/WPS/2.0/req/service/model/handling</semx>
                         </td>
                      </tr>
                      <tr>
                         <th>Normative statements</th>
                         <td>
                            <bookmark id="_"/>
                            <span class="fmt-caption-label">
                               <semx element="autonum" source="_">
                                  <span class="fmt-element-name">Requirement</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-autonum-delim">-</span>
                                  <semx element="autonum" source="_">1</semx>
                               </semx>
                            </span>
                            <semx element="description" source="_">
                               <em>
                                  GetStatus request shall comply with the structure defined in
                                  <xref target="fig-getstatus-request-uml">[fig-getstatus-request-uml]</xref>
                                  and
                                  <xref target="tab-addition-properties-in-the-getstatus-request">[tab-addition-properties-in-the-getstatus-request]</xref>
                                  .
                               </em>
                            </semx>
                            <br/>
                            <bookmark id="_"/>
                            <span class="fmt-caption-label">
                               <semx element="autonum" source="_">
                                  <span class="fmt-element-name">Requirement</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-autonum-delim">-</span>
                                  <semx element="autonum" source="_">2</semx>
                               </semx>
                            </span>
                            <semx element="description" source="_">
                               <em>The JobID used in the request shall be a valid identifier which the client has received with the execute response.</em>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </requirement>
       </foreword>
    OUTPUT
        out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end
end
