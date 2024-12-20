require "spec_helper"

RSpec.describe Metanorma::Requirements::Modspec do
  it "processes permissions" do
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit><eref type="inline" bibitemid="rfc2616" citeas="RFC 2616">RFC 2616 (HTTP/1.1)</eref></inherit>
        <subject>user</subject>
        <classification> <tag>control-CLASS</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>Family</tag> <value>System and Communications Protocols</value> </classification>
        <description>
          <p id="_">I recommend <em>this</em>.</p>
        </description>
        <specification exclude="true" type="tabular">
          <p id="_">This is the object of the recommendation:</p>
          <table id="_">
            <tbody>
              <tr>
                <td style="text-align:left;">Object</td>
                <td style="text-align:left;">Value</td>
                <td style="text-align:left;">Accomplished</td>
              </tr>
            </tbody>
          </table>
        </specification>
        <description>
        <dl>
        <dt>A</dt><dd>B</dd>
        <dt>C</dt><dd>D</dd>
        </dl>
        </description>
        <measurement-target exclude="false">
          <p id="_">The measurement target shall be measured as:</p>
          <formula id="B">
            <stem type="AsciiMath">r/1 = 0</stem>
          </formula>
        </measurement-target>
        <verification exclude="false">
          <p id="_">The following code will be run for verification:</p>
          <sourcecode id="_">CoreRoot(success): HttpResponse
            if (success)
            recommendation(label: success-response)
            end
          </sourcecode>
        </verification>
        <import exclude="true">
          <sourcecode id="_">success-response()</sourcecode>
        </import>
        <component class="test-purpose"><p>TEST PURPOSE</p></component>
        <component class="test-method"><p>TEST METHOD</p></component>
        <component class="conditions"><p>CONDITIONS</p></component>
        <component class="part"><p>FIRST PART</p></component>
        <component class="part"><p>SECOND PART</p></component>
        <component class="part"><p>THIRD PART</p></component>
        <component class="reference"><p>REFERENCE PART</p></component>
        <component class="panda GHz express"><p>PANDA PART</p></component>
      </permission>
          </foreword></preface>
          <bibliography><references id="_bibliography" obligation="informative" normative="false">
      <title>Bibliography</title>
      <bibitem id="rfc2616" type="standard"> <fetched>2020-03-27</fetched> <title format="text/plain" language="en" script="Latn">Hypertext Transfer Protocol — HTTP/1.1</title> <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri> <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri> <docidentifier type="IETF">RFC 2616</docidentifier> <docidentifier type="IETF" scope="anchor">RFC2616</docidentifier> <docidentifier type="DOI">10.17487/RFC2616</docidentifier> <date type="published">  <on>1999-06</on> </date> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">R. Fielding</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Gettys</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Mogul</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">H. Frystyk</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">L. Masinter</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">P. Leach</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">T. Berners-Lee</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <language>en</language> <script>Latn</script> <abstract format="text/plain" language="en" script="Latn">HTTP has been in use by the World-Wide Web global information initiative since 1990. This specification defines the protocol referred to as “HTTP/1.1”, and is an update to RFC 2068. [STANDARDS-TRACK]</abstract> <series type="main">  <title format="text/plain" language="en" script="Latn">RFC</title>  <number>2616</number> </series> <place>Fremont, CA</place></bibitem>
      </references></bibliography>
          </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
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
                                <span class="fmt-element-name">Permission</span>
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
                    <th>Subject</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Prerequisites</th>
                    <td>
                       /ss/584/2015/level/1
                       <br/>
                       <xref type="inline" target="rfc2616">RFC 2616 (HTTP/1.1)</xref>
                    </td>
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
                    <td>
                       System and Communications Protection
                       <br/>
                       System and Communications Protocols
                    </td>
                 </tr>
                 <tr>
                    <th>Statement</th>
                    <td>
                       <p id="_">
                          I recommend
                          <em>this</em>
                          .
                       </p>
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
                       <formula id="B" autonum="1">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-autonum-delim">(</span>
                                1
                                <span class="fmt-autonum-delim">)</span>
                             </span>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <fmt-xref-label container="A">
                             <span class="fmt-xref-container">
                                <semx element="foreword" source="A">Preface</semx>
                             </span>
                             <span class="fmt-comma">,</span>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <stem type="AsciiMath">r/1 = 0</stem>
                       </formula>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The following code will be run for verification:</p>
                       <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
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
    OUTPUT

    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes permission verifications" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface>
              <foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="verification">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <subject>user</subject>
        <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
        <description>
          <p id="_">I recommend <em>this</em>.</p>
        </description>
        <specification exclude="true" type="tabular">
          <p id="_">This is the object of the recommendation:</p>
          <table id="_">
            <tbody>
              <tr>
                <td style="text-align:left;">Object</td>
                <td style="text-align:left;">Value</td>
                <td style="text-align:left;">Accomplished</td>
              </tr>
            </tbody>
          </table>
        </specification>
        <description>
        <dl>
        <dt>A</dt><dd>B</dd>
        <dt>C</dt><dd>D</dd>
        </dl>
        </description>
        <measurement-target exclude="false">
          <p id="_">The measurement target shall be measured as:</p>
          <formula id="B">
            <stem type="AsciiMath">r/1 = 0</stem>
          </formula>
        </measurement-target>
        <verification exclude="false">
          <p id="_">The following code will be run for verification:</p>
          <sourcecode id="_">CoreRoot(success): HttpResponse
            if (success)
            recommendation(label: success-response)
            end
          </sourcecode>
        </verification>
        <import exclude="true">
          <sourcecode id="_">success-response()</sourcecode>
        </import>
      </permission>
          </foreword></preface>
          </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
       <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommendtest" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTestTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Conformance test</span>
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
                    <th>Subject</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Prerequisite</th>
                    <td>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                    <th>Control-class</th>
                    <td>Technical</td>
                 </tr>
                 <tr>
                    <th>Priority</th>
                    <td>P0</td>
                 </tr>
                 <tr>
                    <th>Family</th>
                    <td>
                       System and Communications Protection
                       <br/>
                       System and Communications Protocols
                    </td>
                 </tr>
                 <tr>
                    <th>Description</th>
                    <td>
                       <p id="_">
                          I recommend
                          <em>this</em>
                          .
                       </p>
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
                       <formula id="B" autonum="1">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-autonum-delim">(</span>
                                1
                                <span class="fmt-autonum-delim">)</span>
                             </span>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <fmt-xref-label container="A">
                             <span class="fmt-xref-container">
                                <semx element="foreword" source="A">Preface</semx>
                             </span>
                             <span class="fmt-comma">,</span>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <stem type="AsciiMath">r/1 = 0</stem>
                       </formula>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The following code will be run for verification:</p>
                       <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
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

  it "processes abstract tests" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface>
              <foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="abstracttest">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <subject>user</subject>
        <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
        <description>
          <p id="_">I recommend <em>this</em>.</p>
        </description>
        <specification exclude="true" type="tabular">
          <p id="_">This is the object of the recommendation:</p>
          <table id="_">
            <tbody>
              <tr>
                <td style="text-align:left;">Object</td>
                <td style="text-align:left;">Value</td>
                <td style="text-align:left;">Accomplished</td>
              </tr>
            </tbody>
          </table>
        </specification>
        <description>
        <dl>
        <dt>A</dt><dd>B</dd>
        <dt>C</dt><dd>D</dd>
        </dl>
        </description>
        <measurement-target exclude="false">
          <p id="_">The measurement target shall be measured as:</p>
          <formula id="B">
            <stem type="AsciiMath">r/1 = 0</stem>
          </formula>
        </measurement-target>
        <verification exclude="false">
          <p id="_">The following code will be run for verification:</p>
          <sourcecode id="_">CoreRoot(success): HttpResponse
            if (success)
            recommendation(label: success-response)
            end
          </sourcecode>
        </verification>
        <import exclude="true">
          <sourcecode id="_">success-response()</sourcecode>
        </import>
      </permission>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
       <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommendtest" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTestTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Abstract test</span>
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
                    <th>Subject</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Prerequisite</th>
                    <td>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                    <th>Control-class</th>
                    <td>Technical</td>
                 </tr>
                 <tr>
                    <th>Priority</th>
                    <td>P0</td>
                 </tr>
                 <tr>
                    <th>Family</th>
                    <td>
                       System and Communications Protection
                       <br/>
                       System and Communications Protocols
                    </td>
                 </tr>
                 <tr>
                    <th>Description</th>
                    <td>
                       <p id="_">
                          I recommend
                          <em>this</em>
                          .
                       </p>
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
                       <formula id="B" autonum="1">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-autonum-delim">(</span>
                                1
                                <span class="fmt-autonum-delim">)</span>
                             </span>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <fmt-xref-label container="A">
                             <span class="fmt-xref-container">
                                <semx element="foreword" source="A">Preface</semx>
                             </span>
                             <span class="fmt-comma">,</span>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <stem type="AsciiMath">r/1 = 0</stem>
                       </formula>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The following code will be run for verification:</p>
                       <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
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

  it "processes permission classes" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="class" keep-with-next="true" keep-lines-together="true">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit>/ss/584/2015/level/2</inherit>
        <subject>user</subject>
        <permission model="ogc" id="A2">
        <identifier>/ogc/recommendation/wfs/10</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
      </permission>
      <permission model="ogc" id="B1">
        <identifier>/ogc/recommendation/wfs/10</identifier>
      </permission>
          </foreword></preface>
          </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
        <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
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
                    <th>Target type</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Prerequisites</th>
                    <td>
                       /ss/584/2015/level/1
                       <br/>
                       /ss/584/2015/level/2
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

  it "processes conformance classes" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="conformanceclass">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit>ABC</inherit>
        <subject>user</subject>
        <classification><tag>target</target><value>ABC</value></classification>
        <classification><tag>indirect-dependency</target><value><link target="http://www.example.com/"/></value></classification>
        <classification><tag>indirect-dependency</target><value>ABC</value></classification>
        <description>Hic incipit</description>
        <permission model="ogc" id="A2">
        <identifier>Permission 1</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
      </permission>
          <permission model="ogc" id="B" type="conformanceclass">
          <identifier>ABC</identifier>
          </permission>
          <permission model="ogc" id="B2">
        <identifier>Permission 1</identifier>
        </permission>
          </foreword></preface>
          </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
        <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Conformance class</span>
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
                    <th>Subject</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Requirements class</th>
                    <td>
                       <span class="fmt-element-name">Conformance class</span>
                       <semx element="autonum" source="B">2</semx>
                       :
                       <tt>
                          <xref style="id" target="B">ABC</xref>
                       </tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Prerequisites</th>
                    <td>
                       /ss/584/2015/level/1
                       <br/>
                       <span class="fmt-element-name">Conformance class</span>
                       <semx element="autonum" source="B">2</semx>
                       :
                       <tt>
                          <xref style="id" target="B">ABC</xref>
                       </tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Indirect prerequisites</th>
                    <td>
                       <link target="http://www.example.com/"/>
                       <br/>
                       <span class="fmt-element-name">Conformance class</span>
                       <semx element="autonum" source="B">2</semx>
                       :
                       <tt>
                          <xref style="id" target="B">ABC</xref>
                       </tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Description</th>
                    <td>Hic incipit</td>
                 </tr>
                 <tr>
                    <th>Conformance tests</th>
                    <td>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Permission</span>
                          <semx element="autonum" source="B2">1</semx>
                          :
                          <tt>
                             <xref style="id" target="B2">Permission 1</xref>
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
              </tbody>
           </table>
           <table id="B" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Conformance class</span>
                                <semx element="autonum" source="B">2</semx>
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
                       <tt>ABC</tt>
                    </td>
                 </tr>
              </tbody>
           </table>
           <table id="B2" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Permission</span>
                                <semx element="autonum" source="B2">1</semx>
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
                       <tt>Permission 1</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Included in</th>
                    <td>
                       <span class="fmt-element-name">Conformance class</span>
                       <semx element="autonum" source="A1">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A1">/ogc/recommendation/wfs/2</xref>
                       </tt>
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

  it "processes conformance classes in French" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
              <bibdata><language>fr</language></bibdata>
          <preface><foreword id="A"><title>Preface</title>
          <permission model="ogc" id="A1" type="conformanceclass">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit>ABC</inherit>
        <subject>user</subject>
        <classification><tag>target</target><value>ABC</value></classification>
        <classification><tag>indirect-dependency</target><value><link target="http://www.example.com/"/></value></classification>
        <classification><tag>indirect-dependency</target><value>ABC</value></classification>
        <description>Hic incipit</description>
        <permission model="ogc" id="A2">
        <identifier>Permission 1</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
      </permission>
          <permission model="ogc" id="B" type="conformanceclass">
          <identifier>ABC</identifier>
          </permission>
          <permission model="ogc" id="B2">
        <identifier>Permission 1</identifier>
        </permission>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
        <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Classe de confirmité</span>
                                <semx element="autonum" source="A1">1</semx>
                             </span>
                          </fmt-name>
                       </p>
                    </th>
                 </tr>
              </thead>
              <tbody>
                 <tr>
                    <th>Identifiant</th>
                    <td>
                       <tt>/ogc/recommendation/wfs/2</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Sujet</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Classe d’exigences</th>
                    <td>
                       <span class="fmt-element-name">Classe de confirmité</span>
                       <semx element="autonum" source="B">2</semx>
                       :
                       <tt>
                          <xref style="id" target="B">ABC</xref>
                       </tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Prérequis</th>
                    <td>
                       /ss/584/2015/level/1
                       <br/>
                       <span class="fmt-element-name">Classe de confirmité</span>
                       <semx element="autonum" source="B">2</semx>
                       :
                       <tt>
                          <xref style="id" target="B">ABC</xref>
                       </tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Prérequis indirect</th>
                    <td>
                       <link target="http://www.example.com/"/>
                       <br/>
                       <span class="fmt-element-name">Classe de confirmité</span>
                       <semx element="autonum" source="B">2</semx>
                       :
                       <tt>
                          <xref style="id" target="B">ABC</xref>
                       </tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Description</th>
                    <td>Hic incipit</td>
                 </tr>
                 <tr>
                    <th>Tests de conformité</th>
                    <td>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Autorisation</span>
                          <semx element="autonum" source="B2">1</semx>
                           :
                          <tt>
                             <xref style="id" target="B2">Permission 1</xref>
                          </tt>
                       </span>
                       <br/>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Exigence</span>
                          <semx element="autonum" source="A3">1-1</semx>
                           :
                          <tt>
                             <xref style="id" target="A3">Requirement 1</xref>
                          </tt>
                       </span>
                       <br/>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Recommandation</span>
                          <semx element="autonum" source="A4">1-1</semx>
                           :
                          <tt>
                             <xref style="id" target="A4">Recommendation 1</xref>
                          </tt>
                       </span>
                    </td>
                 </tr>
              </tbody>
           </table>
           <table id="B" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Classe de confirmité</span>
                                <semx element="autonum" source="B">2</semx>
                             </span>
                          </fmt-name>
                       </p>
                    </th>
                 </tr>
              </thead>
              <tbody>
                 <tr>
                    <th>Identifiant</th>
                    <td>
                       <tt>ABC</tt>
                    </td>
                 </tr>
              </tbody>
           </table>
           <table id="B2" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Autorisation</span>
                                <semx element="autonum" source="B2">1</semx>
                             </span>
                          </fmt-name>
                       </p>
                    </th>
                 </tr>
              </thead>
              <tbody>
                 <tr>
                    <th>Identifiant</th>
                    <td>
                       <tt>Permission 1</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Inclus dans</th>
                    <td>
                       <span class="fmt-element-name">Classe de confirmité</span>
                       <semx element="autonum" source="A1">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A1">/ogc/recommendation/wfs/2</xref>
                       </tt>
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

  it "processes requirement classes" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <requirement model="ogc" id="A1" type="class">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit>/ss/584/2015/level/2</inherit>
        <classification><tag>implements</target><value>Permission 1</value></classification>
        <subject>user</subject>
        <description>Hic incipit</description>
        <permission model="ogc" id="A2">
        <identifier>Permission 1</identifier>
        </permission>
        <requirement model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </requirement>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
      </requirement>
      <permission model="ogc" id="A5">
        <identifier>Permission 1</identifier>
        </permission>
          </foreword></preface>
          </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
        <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Requirements class</span>
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
                    <th>Target type</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Prerequisites</th>
                    <td>
                       /ss/584/2015/level/1
                       <br/>
                       /ss/584/2015/level/2
                    </td>
                 </tr>
                 <tr>
                    <th>Implements</th>
                    <td>
                       <span class="fmt-element-name">Permission</span>
                       <semx element="autonum" source="A5">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A5">Permission 1</xref>
                       </tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Description</th>
                    <td>Hic incipit</td>
                 </tr>
                 <tr>
                    <th>Normative statements</th>
                    <td>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Permission</span>
                          <semx element="autonum" source="A5">1</semx>
                          :
                          <tt>
                             <xref style="id" target="A5">Permission 1</xref>
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
              </tbody>
           </table>
           <table id="A5" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Permission</span>
                                <semx element="autonum" source="A5">1</semx>
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
                       <tt>Permission 1</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Included in</th>
                    <td>
                       <span class="fmt-element-name">Requirements class</span>
                       <semx element="autonum" source="A1">1</semx>
                       :
                       <tt>
                          <xref style="id" target="A1">/ogc/recommendation/wfs/2</xref>
                       </tt>
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

  it "processes recommendation classes" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A"><title>Preface</title>
          <recommendation model="ogc" id="A1" type="class">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit>/ss/584/2015/level/2</inherit>
        <subject>user</subject>
        <permission model="ogc" id="A2">
        <identifier>Permission 1</identifier>
        </permission>
        <permission model="ogc" id="A3">
        <identifier>Requirement 1</identifier>
        </permission>
        <recommendation model="ogc" id="A4">
        <identifier>Recommendation 1</identifier>
        </recommendation>
      </recommendation>
          </foreword></preface>
          </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
       <foreword id="A" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A1" type="recommendclass" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Recommendations class</span>
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
                    <th>Target type</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Prerequisites</th>
                    <td>
                       /ss/584/2015/level/1
                       <br/>
                       /ss/584/2015/level/2
                    </td>
                 </tr>
                 <tr>
                    <th>Normative statements</th>
                    <td>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Permission</span>
                          <semx element="autonum" source="A2">1-1</semx>
                          :
                          <tt>
                             <xref style="id" target="A2">Permission 1</xref>
                          </tt>
                       </span>
                       <br/>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Permission</span>
                          <semx element="autonum" source="A3">1-2</semx>
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

  it "processes requirements" do
    input = <<~INPUT
                <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface><foreword id="A0"><title>Preface</title>
          <requirement model="ogc" id="A" unnumbered="true">
        <title>A New Requirement</title>
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <subject>user</subject>
        <description>
          <p id="_">I recommend <em>this</em>.</p>
        </description>
        <specification exclude="true" type="tabular" keep-with-next="true" keep-lines-together="true">
          <p id="_">This is the object of the recommendation:</p>
          <table id="_">
            <tbody>
              <tr>
                <td style="text-align:left;">Object</td>
                <td style="text-align:left;">Value</td>
              </tr>
              <tr>
                <td style="text-align:left;">Mission</td>
                <td style="text-align:left;">Accomplished</td>
              </tr>
            </tbody>
          </table>
        </specification>
        <description>
          <p id="_">As for the measurement targets,</p>
        </description>
        <measurement-target exclude="false">
          <p id="_">The measurement target shall be measured as:</p>
          <formula id="B">
            <stem type="AsciiMath">r/1 = 0</stem>
          </formula>
        </measurement-target>
        <verification exclude="false">
          <p id="_">The following code will be run for verification:</p>
          <sourcecode id="_">CoreRoot(success): HttpResponse
            if (success)
            recommendation(label: success-response)
            end
          </sourcecode>
        </verification>
        <import exclude="true">
          <sourcecode id="_">success-response()</sourcecode>
        </import>
      </requirement>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
       <foreword id="A0" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1">
              <semx element="title" id="_">Preface</semx>
           </fmt-title>
           <table id="A" unnumbered="true" type="recommend" class="modspec">
              <thead>
                 <tr>
                    <th scope="colgroup" colspan="2">
                       <p class="RecommendationTitle">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Requirement</span>
                                <span class="fmt-caption-delim">: </span>
                                <semx element="title" source="A">A New Requirement</semx>
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
                    <th>Statements</th>
                    <td>
                       <p id="_">
                          I recommend
                          <em>this</em>
                          .
                       </p>
                       <br/>
                       <p id="_">As for the measurement targets,</p>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The measurement target shall be measured as:</p>
                       <formula id="B" autonum="1">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-autonum-delim">(</span>
                                1
                                <span class="fmt-autonum-delim">)</span>
                             </span>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <fmt-xref-label container="A0">
                             <span class="fmt-xref-container">
                                <semx element="foreword" source="A0">Preface</semx>
                             </span>
                             <span class="fmt-comma">,</span>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <stem type="AsciiMath">r/1 = 0</stem>
                       </formula>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The following code will be run for verification:</p>
                       <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
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

  it "processes recommendations" do
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <bibdata><language>en</language></bibdata>
          <preface><foreword id="A"><title>Preface</title>
          <recommendation model="ogc" id="_">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <subject>user</subject>
        <description>
          <p id="_">I recommend <em>this</em>.</p>
        </description>
        <specification exclude="true" type="tabular">
          <p id="_">This is the object of the recommendation:</p>
          <table id="_">
            <tbody>
              <tr>
                <td style="text-align:left;">Object</td>
                <td style="text-align:left;">Value</td>
              </tr>
              <tr>
                <td style="text-align:left;">Mission</td>
                <td style="text-align:left;">Accomplished</td>
              </tr>
            </tbody>
          </table>
        </specification>
        <description>
          <p id="_">As for the measurement targets,</p>
        </description>
        <measurement-target exclude="false">
          <p id="_">The measurement target shall be measured as:</p>
          <formula id="B">
            <stem type="AsciiMath">r/1 = 0</stem>
          </formula>
        </measurement-target>
        <verification exclude="false">
          <p id="_">The following code will be run for verification:</p>
          <sourcecode id="_">CoreRoot(success): HttpResponse
            if (success)
            recommendation(label: success-response)
            end
          </sourcecode>
        </verification>
        <import exclude="true">
          <sourcecode id="_">success-response()</sourcecode>
        </import>
      </recommendation>
          </foreword></preface>
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
                    <th>Statements</th>
                    <td>
                       <p id="_">
                          I recommend
                          <em>this</em>
                          .
                       </p>
                       <br/>
                       <p id="_">As for the measurement targets,</p>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The measurement target shall be measured as:</p>
                       <formula id="B" autonum="1">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-autonum-delim">(</span>
                                1
                                <span class="fmt-autonum-delim">)</span>
                             </span>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <fmt-xref-label container="A">
                             <span class="fmt-xref-container">
                                <semx element="foreword" source="A">Preface</semx>
                             </span>
                             <span class="fmt-comma">,</span>
                             <span class="fmt-element-name">Formula</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <stem type="AsciiMath">r/1 = 0</stem>
                       </formula>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The following code will be run for verification:</p>
                       <sourcecode id="_" autonum="1">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
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
                                <span class="fmt-element-name">Recommandation</span>
                                <semx element="autonum" source="_">1</semx>
                             </span>
                          </fmt-name>
                       </p>
                    </th>
                 </tr>
              </thead>
              <tbody>
                 <tr>
                    <th>Identifiant</th>
                    <td>
                       <tt>/ogc/recommendation/wfs/2</tt>
                    </td>
                 </tr>
                 <tr>
                    <th>Sujet</th>
                    <td>user</td>
                 </tr>
                 <tr>
                    <th>Prérequis</th>
                    <td>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                    <th>Déclarations</th>
                    <td>
                       <p id="_">
                          I recommend
                          <em>this</em>
                          .
                       </p>
                       <br/>
                       <p id="_">As for the measurement targets,</p>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The measurement target shall be measured as:</p>
                       <formula id="B" autonum="1">
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-autonum-delim">(</span>
                                1
                                <span class="fmt-autonum-delim">)</span>
                             </span>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Formule</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <fmt-xref-label container="A">
                             <span class="fmt-xref-container">
                                <semx element="foreword" source="A">Preface</semx>
                             </span>
                             <span class="fmt-comma">,</span>
                             <span class="fmt-element-name">Formule</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="B">1</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <stem type="AsciiMath">r/1 = 0</stem>
                       </formula>
                    </td>
                 </tr>
                 <tr>
                    <td colspan="2">
                       <p id="_">The following code will be run for verification:</p>
                       <sourcecode id="_" autonum="1">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
                    </td>
                 </tr>
              </tbody>
           </table>
        </foreword>
    OUTPUT
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input
      .sub("<language>en</language>", "<language>fr</language>"), true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)

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
                               <span class="fmt-element-name">Provision</span>
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
                   <th>Statements</th>
                   <td>
                      <p id="_">
                         I recommend
                         <em>this</em>
                         .
                      </p>
                      <br/>
                      <p id="_">As for the measurement targets,</p>
                   </td>
                </tr>
                <tr>
                   <td colspan="2">
                      <p id="_">The measurement target shall be measured as:</p>
                      <formula id="B" autonum="1">
                         <fmt-name>
                            <span class="fmt-caption-label">
                               <span class="fmt-autonum-delim">(</span>
                               1
                               <span class="fmt-autonum-delim">)</span>
                            </span>
                         </fmt-name>
                         <fmt-xref-label>
                            <span class="fmt-element-name">Formula</span>
                            <span class="fmt-autonum-delim">(</span>
                            <semx element="autonum" source="B">1</semx>
                            <span class="fmt-autonum-delim">)</span>
                         </fmt-xref-label>
                         <fmt-xref-label container="A">
                            <span class="fmt-xref-container">
                               <semx element="foreword" source="A">Preface</semx>
                            </span>
                            <span class="fmt-comma">,</span>
                            <span class="fmt-element-name">Formula</span>
                            <span class="fmt-autonum-delim">(</span>
                            <semx element="autonum" source="B">1</semx>
                            <span class="fmt-autonum-delim">)</span>
                         </fmt-xref-label>
                         <stem type="AsciiMath">r/1 = 0</stem>
                      </formula>
                   </td>
                </tr>
                <tr>
                   <td colspan="2">
                      <p id="_">The following code will be run for verification:</p>
                      <sourcecode id="_" autonum="1">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
                   </td>
                </tr>
             </tbody>
          </table>
       </foreword>
    OUTPUT
    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input
      .sub("<recommendation ", "<recommendation class='Provision' "), true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end
end
