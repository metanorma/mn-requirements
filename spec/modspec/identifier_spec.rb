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
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <preface>
           <foreword id='A' displayorder='1'>
             <title>Preface</title>
             <table id='A1' keep-with-next='true' keep-lines-together='true' class='modspec' type='recommendclass'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permissions class 1</p>
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
                     <xref target='B1'>
                       Permission 1:
                       <tt>/ogc/recommendation/wfs/10</tt>
                     </xref>
                     <br/>
                     <xref target='A3'>
                       Requirement 1-1:
                       <tt>Requirement 1</tt>
                     </xref>
                     <br/>
                     <xref target='A4'>
                       Recommendation 1-1:
                       <tt>Recommendation 1</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Description</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1' style='id'>/ogc/recommendation/wfs/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='B1' class='modspec' type='recommend'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1</p>
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
                     <xref target='A1'>
                       Permissions class 1:
                       <tt>/ogc/recommendation/wfs/2</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Statement</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1' style='id'>/ogc/recommendation/wfs/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <p>
               <xref target='A1'>
                 Permissions class 1:
                 <tt>/ogc/recommendation/wfs/2</tt>
               </xref>
               <xref target='B1'>
                 Permission 1:
                 <tt>/ogc/recommendation/wfs/10</tt>
               </xref>
               <xref target='A1' style='id'>A1</xref>
               <xref target='B1' style='id'>B1</xref>
               <xref target='A1' style='id'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1' style='id'>/ogc/recommendation/wfs/10</xref>
               <xref target='A'>/ogc/recommendation/wfs/2</xref>
               <xref target='A1'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1'>/ogc/recommendation/wfs/10</xref>
             </p>
           </foreword>
         </preface>
       </ogc-standard>
    OUTPUT

    expect(xmlpp(IsoDoc::PresentationXMLConvert.new({})
            .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
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
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <preface>
           <foreword id='A' displayorder='1'>
             <title>Preface</title>
             <table id='A1' keep-with-next='true' keep-lines-together='true' class='modspec' type='recommendclass'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permissions class 1</p>
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
                     <xref target='B1'>
                       Permission 1:
                       <tt>/recommendation/wfs/10</tt>
                     </xref>
                     <br/>
                     <xref target='A3'>
                       Requirement 1-1:
                       <tt>Requirement 1</tt>
                     </xref>
                     <br/>
                     <xref target='A4'>
                       Recommendation 1-1:
                       <tt>Recommendation 1</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Description</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/recommendation/wfs/2</xref>
                     <xref target='B1' style='id'>/recommendation/wfs/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='B1' class='modspec' type='recommend'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1</p>
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
                     <xref target='A1'>
                       Permissions class 1:
                       <tt>/recommendation/wfs/2</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Statement</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/recommendation/wfs/2</xref>
                     <xref target='B1' style='id'>/recommendation/wfs/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <p>
               <xref target='A1'>
                 Permissions class 1:
                 <tt>/ogc/recommendation/wfs/2</tt>
               </xref>
               <xref target='B1'>
                 Permission 1:
                 <tt>/ogc/recommendation/wfs/10</tt>
               </xref>
               <xref target='A1' style='id'>A1</xref>
               <xref target='B1' style='id'>B1</xref>
               <xref target='A1' style='id'>/recommendation/wfs/2</xref>
               <xref target='B1' style='id'>/recommendation/wfs/10</xref>
               <xref target='A'>/ogc/recommendation/wfs/2</xref>
               <xref target='A1'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1'>/ogc/recommendation/wfs/10</xref>
             </p>
           </foreword>
         </preface>
       </ogc-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::PresentationXMLConvert
      .new({ modspecidentifierbase: "/ogc" })
               .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
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
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <preface>
           <foreword id='A' displayorder='1'>
             <title>Preface</title>
             <table id='A1' keep-with-next='true' keep-lines-together='true' class='modspec' type='recommendclass'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permissions class 1</p>
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
                     <xref target='B1'>
                       Permission 1:
                       <tt>/10</tt>
                     </xref>
                     <br/>
                     <xref target='A3'>
                       Requirement 1-1:
                       <tt>Requirement 1</tt>
                     </xref>
                     <br/>
                     <xref target='A4'>
                       Recommendation 1-1:
                       <tt>Recommendation 1</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Description</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/2</xref>
                     <xref target='B1' style='id'>/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='B1' class='modspec' type='recommend'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1</p>
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
                     <xref target='A1'>
                       Permissions class 1:
                       <tt>/wfs/2</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Statement</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/wfs/2</xref>
                     <xref target='B1' style='id'>/wfs/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <p>
               <xref target='A1'>
                 Permissions class 1:
                 <tt>/ogc/recommendation/wfs/2</tt>
               </xref>
               <xref target='B1'>
                 Permission 1:
                 <tt>/ogc/recommendation/wfs/10</tt>
               </xref>
               <xref target='A1' style='id'>A1</xref>
               <xref target='B1' style='id'>B1</xref>
               <xref target='A1' style='id'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1' style='id'>/ogc/recommendation/wfs/10</xref>
               <xref target='A'>/ogc/recommendation/wfs/2</xref>
               <xref target='A1'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1'>/ogc/recommendation/wfs/10</xref>
             </p>
                       </foreword>
         </preface>
       </ogc-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::PresentationXMLConvert
      .new({})
               .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
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
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <preface>
           <foreword id='A' displayorder='1'>
             <title>Preface</title>
             <table id='A1' keep-with-next='true' keep-lines-together='true' class='modspec' type='recommendclass'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permissions class 1</p>
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
                     <xref target='B1'>
                       Permission 1:
                       <tt>/10</tt>
                     </xref>
                     <br/>
                     <xref target='A3'>
                       Requirement 1-1:
                       <tt>Requirement 1</tt>
                     </xref>
                     <br/>
                     <xref target='A4'>
                       Recommendation 1-1:
                       <tt>Recommendation 1</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Description</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/2</xref>
                     <xref target='B1' style='id'>/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='B1' class='modspec' type='recommend'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1</p>
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
                     <xref target='A1'>
                       Permissions class 1:
                       <tt>/2</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Statement</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/2</xref>
                     <xref target='B1' style='id'>/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <p>
               <xref target='A1'>
                 Permissions class 1:
                 <tt>/ogc/recommendation/wfs/2</tt>
               </xref>
               <xref target='B1'>
                 Permission 1:
                 <tt>/ogc/recommendation/wfs/10</tt>
               </xref>
               <xref target='A1' style='id'>A1</xref>
               <xref target='B1' style='id'>B1</xref>
               <xref target='A1' style='id'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1' style='id'>/ogc/recommendation/wfs/10</xref>
               <xref target='A'>/ogc/recommendation/wfs/2</xref>
               <xref target='A1'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1'>/ogc/recommendation/wfs/10</xref>
             </p>
                       </foreword>
         </preface>
       </ogc-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::PresentationXMLConvert
      .new({})
               .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
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
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <preface>
           <foreword id='A' displayorder='1'>
             <title>Preface</title>
             <table id='A1' keep-with-next='true' keep-lines-together='true' class='modspec' type='recommendclass'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permissions class 1</p>
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
                     <xref target='B1'>
                       Permission 1:
                       <tt>/recommendation/wfs/10</tt>
                     </xref>
                     <br/>
                     <xref target='A3'>
                       Requirement 1-1:
                       <tt>Requirement 1</tt>
                     </xref>
                     <br/>
                     <xref target='A4'>
                       Recommendation 1-1:
                       <tt>Recommendation 1</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Description</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/2</xref>
                     <xref target='B1' style='id'>/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='B1' class='modspec' type='recommend'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1</p>
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
                     <xref target='A1'>
                       Permissions class 1:
                       <tt>/2</tt>
                     </xref>
                   </td>
                 </tr>
                 <tr>
                   <th>Statement</th>
                   <td>
                     <xref target='A' style='id'>/ogc/recommendation/wfs/2</xref>
                     <xref target='A1' style='id'>/2</xref>
                     <xref target='B1' style='id'>/10</xref>
                     <xref target='A1'>/ogc/recommendation/wfs/2</xref>
                     <xref target='B1'>/ogc/recommendation/wfs/10</xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <p>
               <xref target='A1'>
                 Permissions class 1:
                 <tt>/ogc/recommendation/wfs/2</tt>
               </xref>
               <xref target='B1'>
                 Permission 1:
                 <tt>/ogc/recommendation/wfs/10</tt>
               </xref>
               <xref target='A1' style='id'>A1</xref>
               <xref target='B1' style='id'>B1</xref>
               <xref target='A1' style='id'>/recommendation/wfs/2</xref>
               <xref target='B1' style='id'>/recommendation/wfs/10</xref>
               <xref target='A'>/ogc/recommendation/wfs/2</xref>
               <xref target='A1'>/ogc/recommendation/wfs/2</xref>
               <xref target='B1'>/ogc/recommendation/wfs/10</xref>
             </p>
                       </foreword>
         </preface>
       </ogc-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::PresentationXMLConvert
      .new({ modspecidentifierbase: "/ogc" })
               .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
  end
end
