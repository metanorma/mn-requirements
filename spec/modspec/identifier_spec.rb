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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <permission model="ogc" type="class" keep-with-next="true" keep-lines-together="true" autonum="1" original-id="A1">
             <fmt-xref-label>
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/2</identifier>
             <permission model="ogc" autonum="1-1" original-id="A2">
                <identifier original-id="_">/ogc/recommendation/wfs/10</identifier>
             </permission>
             <requirement model="ogc" autonum="1-1" original-id="A3">
                <identifier original-id="_">Requirement 1</identifier>
             </requirement>
             <recommendation model="ogc" autonum="1-1" original-id="A4">
                <identifier original-id="_">Recommendation 1</identifier>
             </recommendation>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
                <xref target="B1"/>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Normative statements</th>
                         <td>
                            <bookmark id="A2"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Permission</span>
                               <semx element="autonum" source="B1">1</semx>
                               :
                               <tt>
                                  <xref style="id" target="B1" id="_">
                                     <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="B1">
                                        <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A3"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Requirement</span>
                               <semx element="autonum" source="A3">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A3" id="_">
                                     <semx element="identifier" source="_">Requirement 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A3">
                                        <semx element="identifier" source="_">Requirement 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A4"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Recommendation</span>
                               <semx element="autonum" source="A4">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A4" id="_">
                                     <semx element="identifier" source="_">Recommendation 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A4">
                                        <semx element="identifier" source="_">Recommendation 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                         </td>
                      </tr>
                      <tr>
                         <th>Description</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">
                                  <span class="fmt-element-name">Permission</span>
                                  <semx element="autonum" source="B1">1</semx>
                                  :
                                  <tt>
                                     <xref style="id" target="B1">
                                        <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                                     </xref>
                                  </tt>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">
                                     <span class="fmt-element-name">Permission</span>
                                     <semx element="autonum" source="B1">1</semx>
                                     :
                                     <tt>
                                        <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                                     </tt>
                                  </fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <permission model="ogc" autonum="1" original-id="B1">
             <fmt-xref-label>
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/10</identifier>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Included in</th>
                         <td>
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A1" id="_">
                                  <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref style="id" target="A1">
                                     <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                                  </fmt-xref>
                               </semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <p>
             <xref target="A1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1">
                   <span class="fmt-element-name">Permissions class</span>
                   <semx element="autonum" source="A1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="B1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="B1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">A1</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">B1</fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
             <xref target="A" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <permission model="ogc" type="class" keep-with-next="true" keep-lines-together="true" autonum="1" original-id="A1">
             <fmt-xref-label container="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label container="modspec-provision">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/2</identifier>
             <permission model="ogc" autonum="1-1" original-id="A2">
                <identifier original-id="_">/ogc/recommendation/wfs/10</identifier>
             </permission>
             <requirement model="ogc" autonum="1-1" original-id="A3">
                <identifier original-id="_">Requirement 1</identifier>
             </requirement>
             <recommendation model="ogc" autonum="1-1" original-id="A4">
                <identifier original-id="_">Recommendation 1</identifier>
             </recommendation>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
                <xref target="B1"/>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/recommendation/wfs/2</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Normative statements</th>
                         <td>
                            <bookmark id="A2"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Permission</span>
                               <semx element="autonum" source="B1">1</semx>
                               :
                               <tt>
                                  <xref style="id" target="B1" id="_">
                                     <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="B1">
                                        <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A3"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Requirement</span>
                               <semx element="autonum" source="A3">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A3" id="_">
                                     <semx element="identifier" source="_">Requirement 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A3">
                                        <semx element="identifier" source="_">Requirement 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A4"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Recommendation</span>
                               <semx element="autonum" source="A4">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A4" id="_">
                                     <semx element="identifier" source="_">Recommendation 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A4">
                                        <semx element="identifier" source="_">Recommendation 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                         </td>
                      </tr>
                      <tr>
                         <th>Description</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">
                                  <span class="fmt-element-name">Permission</span>
                                  <semx element="autonum" source="B1">1</semx>
                                  :
                                  <tt>
                                     <xref style="id" target="B1">
                                        <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                                     </xref>
                                  </tt>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">
                                     <span class="fmt-element-name">Permission</span>
                                     <semx element="autonum" source="B1">1</semx>
                                     :
                                     <tt>
                                        <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                                     </tt>
                                  </fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <permission model="ogc" autonum="1" original-id="B1">
             <fmt-xref-label container="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label container="modspec-provision">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/10</identifier>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Included in</th>
                         <td>
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A1" id="_">
                                  <semx element="identifier" source="_">/recommendation/wfs/2</semx>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref style="id" target="A1">
                                     <semx element="identifier" source="_">/recommendation/wfs/2</semx>
                                  </fmt-xref>
                               </semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <p>
             <xref target="A1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1">
                   <span class="fmt-element-name">Permissions class</span>
                   <semx element="autonum" source="A1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="B1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="B1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">A1</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">B1</fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_">/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_">/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">/recommendation/wfs/10</fmt-xref>
             </semx>
             <xref target="A" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <permission model="ogc" type="class" keep-with-next="true" keep-lines-together="true" autonum="1" original-id="A1">
             <fmt-xref-label container="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/2</identifier>
             <classification>
                <tag>identifier-base</tag>
                <value>/ogc/recommendation/wfs</value>
             </classification>
             <permission model="ogc" autonum="1-1" original-id="A2">
                <identifier original-id="_">/ogc/recommendation/wfs/10</identifier>
             </permission>
             <requirement model="ogc" autonum="1-1" original-id="A3">
                <identifier original-id="_">Requirement 1</identifier>
             </requirement>
             <recommendation model="ogc" autonum="1-1" original-id="A4">
                <identifier original-id="_">Recommendation 1</identifier>
             </recommendation>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
                <xref target="B1"/>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/2</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Normative statements</th>
                         <td>
                            <bookmark id="A2"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Permission</span>
                               <semx element="autonum" source="B1">1</semx>
                               :
                               <tt>
                                  <xref style="id" target="B1" id="_">
                                     <semx element="identifier" source="_">/10</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="B1">
                                        <semx element="identifier" source="_">/10</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A3"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Requirement</span>
                               <semx element="autonum" source="A3">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A3" id="_">
                                     <semx element="identifier" source="_">Requirement 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A3">
                                        <semx element="identifier" source="_">Requirement 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A4"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Recommendation</span>
                               <semx element="autonum" source="A4">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A4" id="_">
                                     <semx element="identifier" source="_">Recommendation 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A4">
                                        <semx element="identifier" source="_">Recommendation 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                         </td>
                      </tr>
                      <tr>
                         <th>Description</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">
                                  <span class="fmt-element-name">Permission</span>
                                  <semx element="autonum" source="B1">1</semx>
                                  :
                                  <tt>
                                     <xref style="id" target="B1">
                                        <semx element="identifier" source="_">/10</semx>
                                     </xref>
                                  </tt>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">
                                     <span class="fmt-element-name">Permission</span>
                                     <semx element="autonum" source="B1">1</semx>
                                     :
                                     <tt>
                                        <semx element="identifier" source="_">/10</semx>
                                     </tt>
                                  </fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <permission model="ogc" autonum="1" original-id="B1">
             <fmt-xref-label container="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/10</identifier>
             <classification>
                <tag>identifier-base</tag>
                <value>/ogc/recommendation</value>
             </classification>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/wfs/10</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Included in</th>
                         <td>
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A1" id="_">
                                  <semx element="identifier" source="_">/wfs/2</semx>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref style="id" target="A1">
                                     <semx element="identifier" source="_">/wfs/2</semx>
                                  </fmt-xref>
                               </semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/wfs/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <p>
             <xref target="A1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1">
                   <span class="fmt-element-name">Permissions class</span>
                   <semx element="autonum" source="A1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="B1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="B1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">A1</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">B1</fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
             <xref target="A" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <permission model="ogc" type="class" keep-with-next="true" keep-lines-together="true" autonum="1" original-id="A1">
             <fmt-xref-label container="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/2</identifier>
             <classification>
                <tag>identifier-base</tag>
                <value>/ogc/recommendation/wfs</value>
             </classification>
             <permission model="ogc" autonum="1-1" original-id="A2">
                <identifier original-id="_">/ogc/recommendation/wfs/10</identifier>
             </permission>
             <requirement model="ogc" autonum="1-1" original-id="A3">
                <identifier original-id="_">Requirement 1</identifier>
             </requirement>
             <recommendation model="ogc" autonum="1-1" original-id="A4">
                <identifier original-id="_">Recommendation 1</identifier>
             </recommendation>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
                <xref target="B1"/>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/2</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Normative statements</th>
                         <td>
                            <bookmark id="A2"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Permission</span>
                               <semx element="autonum" source="B1">1</semx>
                               :
                               <tt>
                                  <xref style="id" target="B1" id="_">
                                     <semx element="identifier" source="_">/10</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="B1">
                                        <semx element="identifier" source="_">/10</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A3"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Requirement</span>
                               <semx element="autonum" source="A3">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A3" id="_">
                                     <semx element="identifier" source="_">Requirement 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A3">
                                        <semx element="identifier" source="_">Requirement 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A4"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Recommendation</span>
                               <semx element="autonum" source="A4">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A4" id="_">
                                     <semx element="identifier" source="_">Recommendation 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A4">
                                        <semx element="identifier" source="_">Recommendation 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                         </td>
                      </tr>
                      <tr>
                         <th>Description</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">
                                  <span class="fmt-element-name">Permission</span>
                                  <semx element="autonum" source="B1">1</semx>
                                  :
                                  <tt>
                                     <xref style="id" target="B1">
                                        <semx element="identifier" source="_">/10</semx>
                                     </xref>
                                  </tt>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">
                                     <span class="fmt-element-name">Permission</span>
                                     <semx element="autonum" source="B1">1</semx>
                                     :
                                     <tt>
                                        <semx element="identifier" source="_">/10</semx>
                                     </tt>
                                  </fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <permission model="ogc" autonum="1" original-id="B1">
             <fmt-xref-label container="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/10</identifier>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/10</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Included in</th>
                         <td>
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A1" id="_">
                                  <semx element="identifier" source="_">/2</semx>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref style="id" target="A1">
                                     <semx element="identifier" source="_">/2</semx>
                                  </fmt-xref>
                               </semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <p>
             <xref target="A1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1">
                   <span class="fmt-element-name">Permissions class</span>
                   <semx element="autonum" source="A1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="B1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="B1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">A1</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">B1</fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
             <xref target="A" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
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
             <semx element="title" source="_">Preface</semx>
          </fmt-title>
          <permission model="ogc" type="class" keep-with-next="true" keep-lines-together="true" autonum="1" original-id="A1">
             <fmt-xref-label container="A1">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label container="modspec-provision">
                <span class="fmt-element-name">Permissions class</span>
                <semx element="autonum" source="A1">1</semx>
                :
                <tt>
                   <xref style="id" target="A1">
                      <semx element="identifier" source="_">/recommendation/wfs/2</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/2</identifier>
             <classification>
                <tag>identifier-base</tag>
                <value>/ogc/recommendation/wfs</value>
             </classification>
             <permission model="ogc" autonum="1-1" original-id="A2">
                <identifier original-id="_">/ogc/recommendation/wfs/10</identifier>
             </permission>
             <requirement model="ogc" autonum="1-1" original-id="A3">
                <identifier original-id="_">Requirement 1</identifier>
             </requirement>
             <recommendation model="ogc" autonum="1-1" original-id="A4">
                <identifier original-id="_">Recommendation 1</identifier>
             </recommendation>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
                <xref target="B1"/>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/2</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Normative statements</th>
                         <td>
                            <bookmark id="A2"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Permission</span>
                               <semx element="autonum" source="B1">1</semx>
                               :
                               <tt>
                                  <xref style="id" target="B1" id="_">
                                     <semx element="identifier" source="_">/10</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="B1">
                                        <semx element="identifier" source="_">/10</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A3"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Requirement</span>
                               <semx element="autonum" source="A3">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A3" id="_">
                                     <semx element="identifier" source="_">Requirement 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A3">
                                        <semx element="identifier" source="_">Requirement 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                            <br/>
                            <bookmark id="A4"/>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Recommendation</span>
                               <semx element="autonum" source="A4">1-1</semx>
                               :
                               <tt>
                                  <xref style="id" target="A4" id="_">
                                     <semx element="identifier" source="_">Recommendation 1</semx>
                                  </xref>
                                  <semx element="xref" source="_">
                                     <fmt-xref style="id" target="A4">
                                        <semx element="identifier" source="_">Recommendation 1</semx>
                                     </fmt-xref>
                                  </semx>
                               </tt>
                            </span>
                         </td>
                      </tr>
                      <tr>
                         <th>Description</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">
                                  <span class="fmt-element-name">Permission</span>
                                  <semx element="autonum" source="B1">1</semx>
                                  :
                                  <tt>
                                     <xref style="id" target="B1">
                                        <semx element="identifier" source="_">/10</semx>
                                     </xref>
                                  </tt>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">
                                     <span class="fmt-element-name">Permission</span>
                                     <semx element="autonum" source="B1">1</semx>
                                     :
                                     <tt>
                                        <semx element="identifier" source="_">/10</semx>
                                     </tt>
                                  </fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <permission model="ogc" autonum="1" original-id="B1">
             <fmt-xref-label container="B1">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label>
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <fmt-xref-label container="modspec-provision">
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="B1">1</semx>
                :
                <tt>
                   <xref style="id" target="B1">
                      <semx element="identifier" source="_">/recommendation/wfs/10</semx>
                   </xref>
                </tt>
             </fmt-xref-label>
             <identifier id="_">/ogc/recommendation/wfs/10</identifier>
             <description id="_">
                <xref target="A" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="A1" style="id">/ogc/recommendation/wfs/2</xref>
                <xref target="B1" style="id">/ogc/recommendation/wfs/10</xref>
                <xref target="A1">/ogc/recommendation/wfs/2</xref>
                <xref target="B1">/ogc/recommendation/wfs/10</xref>
             </description>
             <fmt-provision>
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
                            <tt>
                               <semx element="identifier" source="_">/10</semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Included in</th>
                         <td>
                            <span class="fmt-element-name">Permissions class</span>
                            <semx element="autonum" source="A1">1</semx>
                            :
                            <tt>
                               <xref style="id" target="A1" id="_">
                                  <semx element="identifier" source="_">/2</semx>
                               </xref>
                               <semx element="xref" source="_">
                                  <fmt-xref style="id" target="A1">
                                     <semx element="identifier" source="_">/2</semx>
                                  </fmt-xref>
                               </semx>
                            </tt>
                         </td>
                      </tr>
                      <tr>
                         <th>Statement</th>
                         <td>
                            <semx element="description" source="_">
                               <xref target="A" style="id" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A" style="id">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="A1" style="id" id="_">/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1" style="id">/2</fmt-xref>
                               </semx>
                               <xref target="B1" style="id" id="_">/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1" style="id">/10</fmt-xref>
                               </semx>
                               <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
                               </semx>
                               <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
                               <semx element="xref" source="_">
                                  <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
                               </semx>
                            </semx>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </fmt-provision>
          </permission>
          <p>
             <xref target="A1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1">
                   <span class="fmt-element-name">Permissions class</span>
                   <semx element="autonum" source="A1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/2</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="B1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="B1">1</semx>
                   :
                   <tt>
                      <semx element="identifier" source="_">/ogc/recommendation/wfs/10</semx>
                   </tt>
                </fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">A1</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">B1</fmt-xref>
             </semx>
             <xref target="A1" style="id" id="_">/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1" style="id">/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" style="id" id="_">/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1" style="id">/recommendation/wfs/10</fmt-xref>
             </semx>
             <xref target="A" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="A1" id="_">/ogc/recommendation/wfs/2</xref>
             <semx element="xref" source="_">
                <fmt-xref target="A1">/ogc/recommendation/wfs/2</fmt-xref>
             </semx>
             <xref target="B1" id="_">/ogc/recommendation/wfs/10</xref>
             <semx element="xref" source="_">
                <fmt-xref target="B1">/ogc/recommendation/wfs/10</fmt-xref>
             </semx>
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
