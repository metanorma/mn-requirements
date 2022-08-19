require "spec_helper"

RSpec.describe Metanorma::Requirements::Modspec do
  it "processes requirement components" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <preface><foreword id="A"><title>Preface</title>
        <recommendation id="_">
      <identifier>/ogc/recommendation/wfs/2</identifier>
      <inherit>/ss/584/2015/level/1</inherit>
      <subject>user</subject>
      <description><p id="_">I recommend <em>1</em>.</p></description>
      <component class="test-purpose"><p>TEST PURPOSE</p></component>
      <description><p id="_">I recommend <em>2</em>.</p></description>
      <component class="conditions"><p>CONDITIONS</p></component>
      <description><p id="_">I recommend <em>3</em>.</p></description>
      <component class="part"><p>FIRST PART</p></component>
      <description><p id="_">I recommend <em>4</em>.</p></description>
      <component class="part"><p>SECOND PART</p></component>
      <description><p id="_">I recommend <em>5</em>.</p></description>
      <component class="test-method"><p>TEST METHOD</p></component>
      <description><p id="_">I recommend <em>6</em>.</p></description>
      <component class="part"><p>THIRD PART</p></component>
      <description><p id="_">I recommend <em>7</em>.</p></description>
      <component class="panda GHz express"><p>PANDA PART</p></component>
      <description><p id="_">I recommend <em>8</em>.</p></description>
      </recommendation>
      </foreword>
      </preface>
      </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A" displayorder="1"><title depth="1">I.<tab/>Preface</title>
           <table id="_" class="recommendation" type="recommend">
         <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Recommendation 1</p></th></tr></thead><tbody><tr><td colspan="2"><p class='RecommendationLabel'>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td colspan="2"><p id="_">I recommend <em>1</em>.</p></td></tr><tr><td>Test purpose</td><td><p>TEST PURPOSE</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>2</em>.</p></td></tr><tr><td>Conditions</td><td><p>CONDITIONS</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>3</em>.</p></td></tr><tr><td>A</td><td><p>FIRST PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>4</em>.</p></td></tr><tr><td>B</td><td><p>SECOND PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>5</em>.</p></td></tr><tr><td>Test method</td><td><p>TEST METHOD</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>6</em>.</p></td></tr><tr><td>C</td><td><p>THIRD PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>7</em>.</p></td></tr><tr><td>Panda GHz express</td><td><p>PANDA PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>8</em>.</p></td></tr></tbody></table>
         </foreword>
         </preface>
         </ogc-standard>
    OUTPUT

    expect(xmlpp(IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes nested requirement steps" do
    input = <<~INPUT
                <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface>
                <foreword id="A"><title>Preface</title>
                    <requirement id='A1'>
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
            <title depth='1'>
              I.
              <tab/>
              Preface
            </title>
            <table id='A1' class='requirement' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Requirement 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Test method type</td>
                  <td>
                    <p id='_'>Manual Inspection</p>
                  </td>
                </tr>
                <tr>
                  <td>Test method</td>
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
    expect(xmlpp(IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes bidirectional requirement/conformance tests" do
    input = <<~INPUT
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <preface>
          <foreword id="A"><title>Preface</title>
              <requirement id='A1' type="general">
              <identifier>/ogc/recommendation/wfs/1</identifier>
              </requirement>
              <requirement id='A2' type="verification">
              <identifier>/ogc/recommendation/wfs/2</identifier>
              <classification><tag>target</tag><value>/ogc/recommendation/wfs/1</value></classification>
              </requirement>
              <requirement id='A3' type="class">
              <identifier>/ogc/recommendation/wfs/3</identifier>
              </requirement>
              <requirement id='A4' type="conformanceclass">
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
             <title depth='1'>
               I.
               <tab/>
               Preface
             </title>
             <table id='A1' type='recommend' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Requirement 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/1</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Conformance test</td>
                   <td><xref target='A2'>/ogc/recommendation/wfs/2</xref></td>
                 </tr>
               </tbody>
             </table>
             <table id='A2' type='recommendtest' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTestTitle'>Requirement test 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Requirement</td>
                   <td><xref target="A1">/ogc/recommendation/wfs/1</xref></td>
                 </tr>
               </tbody>
             </table>
             <table id='A3' type='recommendclass' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Requirements class 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/3</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Conformance test</td>
                   <td><xref target='A4'>/ogc/recommendation/wfs/4</xref></td>
                 </tr>
               </tbody>
             </table>
             <table id='A4' type='recommendclass' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Conformance class 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/4</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Requirements class</td>
                   <td><xref target='A3'>/ogc/recommendation/wfs/3</xref></td>
                 </tr>
               </tbody>
             </table>
           </foreword>
         </preface>
       </ogc-standard>
    PRESXML
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
  end
end
