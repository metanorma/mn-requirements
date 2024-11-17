require "spec_helper"

RSpec.describe Metanorma::Requirements::Default do
  it "processes permissions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <permission id="A"   keep-with-next="true" keep-lines-together="true" model="default">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit><eref type="inline" bibitemid="rfc2616" citeas="RFC 2616">RFC 2616 (HTTP/1.1)</eref></inherit>
        <subject>user</subject>
        <subject>non-user</subject>
        <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
        <description>
          <p id="_">I recommend <em>this</em>.</p>
          <classification><tag>scope</tag><value>random</value></classification><classification><tag>widgets</tag><value>randomer</value></classification>
        </description>
        <note id="N">This is a note</note>
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
        <component exclude='false' class='component1'>
                  <p id='_'>Hello</p>
                </component>
      </permission>
          </foreword></preface>
          <bibliography><references id="_bibliography" obligation="informative" normative="false" displayorder="2">
      <title>Bibliography</title>
      <bibitem id="rfc2616" type="standard">  <fetched>2020-03-27</fetched>  <title format="text/plain" language="en" script="Latn">Hypertext Transfer Protocol — HTTP/1.1</title>  <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri>  <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri>  <docidentifier type="IETF">RFC 2616</docidentifier>  <docidentifier type="IETF" scope="anchor">RFC2616</docidentifier>  <docidentifier type="DOI">10.17487/RFC2616</docidentifier>  <date type="published">    <on>1999-06</on>  </date>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">R. Fielding</completename>      </name>      <affiliation>        <organization>          <name>IETF</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">J. Gettys</completename>      </name>      <affiliation>        <organization>          <name>IETF</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">J. Mogul</completename>      </name>      <affiliation>        <organization>          <name>IETF</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">H. Frystyk</completename>      </name>      <affiliation>        <organization>          <name>IETF</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">L. Masinter</completename>      </name>      <affiliation>        <organization>          <name>IETF</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">P. Leach</completename>      </name>      <affiliation>        <organization>          <name>IETF</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <contributor>    <role type="author"/>    <person>      <name>        <completename language="en">T. Berners-Lee</completename>      </name>      <affiliation>        <organization>          <name>IETF</name>          <abbreviation>IETF</abbreviation>        </organization>      </affiliation>    </person>  </contributor>  <language>en</language>  <script>Latn</script>  <abstract format="text/plain" language="en" script="Latn">HTTP has been in use by the World-Wide Web global information initiative since 1990. This specification defines the protocol referred to as “HTTP/1.1”, and is an update to RFC 2068.  [STANDARDS-TRACK]</abstract>  <series type="main">    <title format="text/plain" language="en" script="Latn">RFC</title>    <number>2616</number>  </series>  <place>Fremont, CA</place></bibitem>
      </references></bibliography>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Foreword</semx>
             </span>
          </fmt-title>
          <permission id="A" keep-with-next="true" keep-lines-together="true" model="default" autonum="1">
             <fmt-name>
                <span class="fmt-caption-label">
                   <span class="fmt-element-name">Permission</span>
                   <semx element="autonum" source="A">1</semx>
                </span>
                :
                <br/>
                /ogc/recommendation/wfs/2
             </fmt-name>
             <p>
                <em>Subject: user</em>
                <br/>
                <em>Subject: non-user</em>
                <br/>
                <em>Inherits: /ss/584/2015/level/1</em>
                <br/>
                <em>
                   Inherits:
                   <xref type="inline" target="rfc2616">RFC 2616 (HTTP/1.1)</xref>
                </em>
                <br/>
                <em>Control-class: Technical</em>
                <br/>
                <em>Priority: P0</em>
                <br/>
                <em>Family: System and Communications Protection</em>
                <br/>
                <em>Family: System and Communications Protocols</em>
             </p>
             <fmt-xref-label>
                <span class="fmt-element-name">Permission</span>
                <semx element="autonum" source="A">1</semx>
             </fmt-xref-label>
             <div type="requirement-description">
                <p id="_">
                   I recommend
                   <em>this</em>
                   .
                </p>
                <dl>
                   <dt>scope</dt>
                   <dd>random</dd>
                   <dt>widgets</dt>
                   <dd>randomer</dd>
                </dl>
             </div>
             <note id="N" autonum="">
                <fmt-name>
                   <span class="fmt-caption-label">
                      <span class="fmt-element-name">NOTE</span>
                   </span>
                </fmt-name>
                <fmt-xref-label>
                   <span class="fmt-element-name">Note</span>
                </fmt-xref-label>
                This is a note
             </note>
             <div type="requirement-description">
                <p id="_">As for the measurement targets,</p>
             </div>
             <div exclude="false" type="requirement-measurement-target">
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
                   <stem type="AsciiMath">r/1 = 0</stem>
                </formula>
             </div>
             <div exclude="false" type="requirement-verification">
                <p id="_">The following code will be run for verification:</p>
                <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
             </div>
             <div exclude="false" class="component1" type="requirement-component1">
                <p id="_">Hello</p>
             </div>
          </permission>
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
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <requirement id="A" unnumbered="true"  keep-with-next="true" keep-lines-together="true" model="default">
        <title>A New Requirement</title>
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
        <measurement-target exclude="false"  keep-with-next="true" keep-lines-together="true">
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
        <component exclude='false' class='component1'>
                  <p id='_'>Hello</p>
                </component>
      </requirement>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Foreword</semx>
             </span>
          </fmt-title>
          <requirement id="A" unnumbered="true" keep-with-next="true" keep-lines-together="true" model="default">
             <fmt-name>
                <span class="fmt-caption-label">
                   <span class="fmt-element-name">Requirement</span>
                </span>
                :
                <br/>
                /ogc/recommendation/wfs/2. A New Requirement
             </fmt-name>
             <p>
                <em>Subject: user</em>
                <br/>
                <em>Inherits: /ss/584/2015/level/1</em>
             </p>
             <fmt-xref-label>
                <span class="fmt-element-name">Requirement</span>
                <semx element="autonum" source="A">(??)</semx>
             </fmt-xref-label>
             <div type="requirement-description">
                <p id="_">
                   I recommend
                   <em>this</em>
                   .
                </p>
             </div>
             <div type="requirement-description">
                <p id="_">As for the measurement targets,</p>
             </div>
             <div exclude="false" keep-with-next="true" keep-lines-together="true" type="requirement-measurement-target">
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
                   <stem type="AsciiMath">r/1 = 0</stem>
                </formula>
             </div>
             <div exclude="false" type="requirement-verification">
                <p id="_">The following code will be run for verification:</p>
                <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
             </div>
             <div exclude="false" class="component1" type="requirement-component1">
                <p id="_">Hello</p>
             </div>
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

  it "processes requirements in French" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>fr</language>
          <script>Latn</script>
          </bibdata>
          <preface><foreword id="F">
          <requirement id="A" unnumbered="true" model="default">
        <title>A New Requirement</title>
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
        <component exclude='false' class='component1'>
                  <p id='_'>Hello</p>
                </component>
      </requirement>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
      <foreword id="F" displayorder="2">
          <title id="_">Avant-propos</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Avant-propos</semx>
             </span>
          </fmt-title>
          <requirement id="A" unnumbered="true" model="default">
             <fmt-name>
                <span class="fmt-caption-label">
                   <span class="fmt-element-name">Exigence</span>
                </span>
                :
                <br/>
                /ogc/recommendation/wfs/2. A New Requirement
             </fmt-name>
             <p>
                <em>Sujet : user</em>
                <br/>
                <em>Hérite : /ss/584/2015/level/1</em>
             </p>
             <fmt-xref-label>
                <span class="fmt-element-name">Exigence</span>
                <semx element="autonum" source="A">(??)</semx>
             </fmt-xref-label>
             <div type="requirement-description">
                <p id="_">
                   I recommend
                   <em>this</em>
                   .
                </p>
             </div>
             <div type="requirement-description">
                <p id="_">As for the measurement targets,</p>
             </div>
             <div exclude="false" type="requirement-measurement-target">
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
                   <stem type="AsciiMath">r/1 = 0</stem>
                </formula>
             </div>
             <div exclude="false" type="requirement-verification">
                <p id="_">The following code will be run for verification:</p>
                <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
             </div>
             <div exclude="false" class="component1" type="requirement-component1">
                <p id="_">Hello</p>
             </div>
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

  it "processes recommendation" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <recommendation id="A" obligation="shall,could"   keep-with-next="true" keep-lines-together="true" model="default">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        <inherit>/ss/584/2015/level/1</inherit>
        <classification><tag>type</tag><value>text</value></classification>
        <classification><tag>language</tag><value>BASIC</value></classification>
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
        <component exclude='false' class='component1'>
                  <p id='_'>Hello</p>
                </component>
      </recommendation>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" id="_">Foreword</semx>
             </span>
          </fmt-title>
          <recommendation id="A" obligation="shall,could" keep-with-next="true" keep-lines-together="true" model="default" autonum="1">
             <fmt-name>
                <span class="fmt-caption-label">
                   <span class="fmt-element-name">Recommendation</span>
                   <semx element="autonum" source="A">1</semx>
                </span>
                :
                <br/>
                /ogc/recommendation/wfs/2
             </fmt-name>
             <p>
                <em>Obligation: shall,could</em>
                <br/>
                <em>Subject: user</em>
                <br/>
                <em>Inherits: /ss/584/2015/level/1</em>
                <br/>
                <em>Type: text</em>
                <br/>
                <em>Language: BASIC</em>
             </p>
             <fmt-xref-label>
                <span class="fmt-element-name">Recommendation</span>
                <semx element="autonum" source="A">1</semx>
             </fmt-xref-label>
             <div type="requirement-description">
                <p id="_">
                   I recommend
                   <em>this</em>
                   .
                </p>
             </div>
             <div type="requirement-description">
                <p id="_">As for the measurement targets,</p>
             </div>
             <div exclude="false" type="requirement-measurement-target">
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
                   <stem type="AsciiMath">r/1 = 0</stem>
                </formula>
             </div>
             <div exclude="false" type="requirement-verification">
                <p id="_">The following code will be run for verification:</p>
                <sourcecode id="_" autonum="2">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
             </div>
             <div exclude="false" class="component1" type="requirement-component1">
                <p id="_">Hello</p>
             </div>
          </recommendation>
       </foreword>
    OUTPUT

    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)

    out = Nokogiri::XML(
      IsoDoc::PresentationXMLConvert.new({})
      .convert("test", input
      .sub("<recommendation ", "<recommendation class='provision' "), true),
    ).at("//xmlns:foreword")
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n
        .format(presxml.sub("<recommendation ",
                            "<recommendation class='provision' ")
      .gsub(/<fmt-name>\s*<span class="fmt-caption-label">\s*<span class="fmt-element-name">Recommendation/,
            '<fmt-name><span class="fmt-caption-label"><span class="fmt-element-name">Provision')
      .gsub(/<fmt-xref-label>\s*<span class="fmt-element-name">Recommendation/,
            '<fmt-xref-label><span class="fmt-element-name">provision'))
  end
end
