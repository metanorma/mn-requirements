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
      <description><p id="_">I recommend <em>1</em>.</p></description>
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
           <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
         <preface>
           <foreword id="A" displayorder="1">
             <title>Preface</title>
             <table id="A1" class="modspec" type="recommend">
               <thead>
                 <tr>
                   <th scope="colgroup" colspan="2">
                     <p class="RecommendationTitle">Permission 1</p>
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
                   <th>Prerequisites</th>
                   <td>/ss/584/2015/level/1<br/><eref type="inline" bibitemid="rfc2616" citeas="RFC 2616">RFC 2616 (HTTP/1.1)</eref></td>
                 </tr>
                 <tr>
                   <th>Control-CLASS</th>
                   <td>Technical</td>
                 </tr>
                 <tr>
                   <th>Priority</th>
                   <td>P0</td>
                 </tr>
                 <tr>
                   <th>Family</th>
                   <td>System and Communications Protection<br/>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <th>Statement</th>
                   <td>
                     <p id="_">I recommend <em>this</em>.</p>
                   </td>
                 </tr>
                 <tr>
                   <th>A</th>
                   <td>B</td>
                 </tr>
                 <tr>
                   <th>C</th>
                   <td>D</td>
                 </tr>
                 <tr>
                   <td colspan="2">
                     <p id="_">The measurement target shall be measured as:</p>
                     <formula id="_">
                       <name>1</name>
                       <stem type="AsciiMath">r/1 = 0</stem>
                     </formula>
                   </td>
                 </tr>
                 <tr>
                   <td colspan="2">
                     <p id="_">The following code will be run for verification:</p>
                     <sourcecode id="_">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
                   </td>
                 </tr>
                 <tr>
                   <th>Test purpose</th>
                   <td>
                     <p>TEST PURPOSE</p>
                   </td>
                 </tr>
                 <tr>
                   <th>Test method</th>
                   <td>
                     <p>TEST METHOD</p>
                   </td>
                 </tr>
                 <tr>
                   <th>Conditions</th>
                   <td>
                     <p>CONDITIONS</p>
                   </td>
                 </tr>
                 <tr>
                   <th>A</th>
                   <td>
                     <p>FIRST PART</p>
                   </td>
                 </tr>
                 <tr>
                   <th>B</th>
                   <td>
                     <p>SECOND PART</p>
                   </td>
                 </tr>
                 <tr>
                   <th>C</th>
                   <td>
                     <p>THIRD PART</p>
                   </td>
                 </tr>
                 <tr>
                   <th>Reference</th>
                   <td>
                     <p>REFERENCE PART</p>
                   </td>
                 </tr>
                 <tr>
                   <th>Panda GHz express</th>
                   <td>
                     <p>PANDA PART</p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </foreword>
         </preface>
         <bibliography>
           <references id="_bibliography" obligation="informative" normative="false" displayorder="2">
             <title depth="1">Bibliography</title>
             <bibitem id="rfc2616" type="standard">
               <formattedref>R. FIELDING, J. GETTYS, J. MOGUL, H. FRYSTYK, L. MASINTER, P. LEACH and T. BERNERS-LEE. <em>Hypertext Transfer Protocol — HTTP/1.1</em>. In: RFC. 1999. Fremont, CA. <link target="https://www.rfc-editor.org/info/rfc2616">https://www.rfc-editor.org/info/rfc2616</link>.</formattedref>
               <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri>
               <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri>
               <docidentifier type="metanorma-ordinal">[1]</docidentifier>
               <docidentifier type="IETF">IETF RFC 2616</docidentifier>
               <docidentifier type="IETF" scope="anchor">IETF RFC2616</docidentifier>
               <docidentifier type="DOI">DOI 10.17487/RFC2616</docidentifier>
               <biblio-tag>[1]<tab/>IETF RFC 2616, </biblio-tag>
             </bibitem>
           </references>
         </bibliography>
       </ogc-standard>
    OUTPUT

    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    )
    out.at("//xmlns:metanorma-extension").remove
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
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
        <preface>
          <foreword id='A' displayorder='1'>
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
        </preface>
      </ogc-standard>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    )
    out.at("//xmlns:metanorma-extension").remove
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
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
        <preface>
          <foreword id='A' displayorder='1'>
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
        </preface>
      </ogc-standard>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    )
    out.at("//xmlns:metanorma-extension").remove
    expect(xmlpp(out.to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end
end
