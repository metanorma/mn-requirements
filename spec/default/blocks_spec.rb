require "spec_helper"
require "open3"

RSpec.describe Metanorma::Requirements::Default do
  it "processes recommendation" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      [[id1]]
      [.recommendation,identifier="/ogc/recommendation/wfs/2",subject="user;developer, implementer",inherit="/ss/584/2015/level/1; /ss/584/2015/level/2",options="unnumbered",type=verification,model=ogc,tag=X,multilingual-rendering=common,class=provision]
      ====
      I recommend this
      ====
    INPUT
    output = <<~"OUTPUT"
      #{BLANK_HDR.sub(/<metanorma-extension>/, <<~EXT
        <metanorma-extension>
          <table id='_' anchor='_misccontainer_anchor_aliases'>
            <tbody>
              <tr>
                <th>id1</th>
                <td>/ogc/recommendation/wfs/2</td>
              </tr>
            </tbody>
          </table>
      EXT
      )}
        <sections>
          <recommendation id="_" anchor="id1" unnumbered="true" type="verification" model="ogc" tag='X' multilingual-rendering='common' class="provision">
             <identifier>/ogc/recommendation/wfs/2</identifier>
             <subject>user</subject>
             <subject>developer, implementer</subject>
             <inherit>/ss/584/2015/level/1</inherit>
             <inherit>/ss/584/2015/level/2</inherit>
               <description><p id="_">I recommend this</p>
             </description>
          </recommendation>
        </sections>
      </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes requirement" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      [[ABC]]
      [.requirement,subsequence="A",inherit="/ss/584/2015/level/1 &amp; /ss/584/2015/level/2",number=3,keep-with-next=true,keep-lines-together=true,tag=X,multilingual-rendering=common,class=provision]
      .Title
      ====
      I recommend this

      . http://www.example.com[]
      . <<ABC>>
      ====
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
             <sections>
        <requirement id="_" anchor="ABC" subsequence="A" number="3" keep-with-next="true" keep-lines-together="true" tag='X' multilingual-rendering='common' model="default" class="provision">
              <title>Title</title>
        <inherit>/ss/584/2015/level/1 &amp; /ss/584/2015/level/2</inherit>
        <description><p id="_">I recommend this</p>
                       <ol id='_' type='arabic'>
                 <li>
                   <p id='_'>
                     <link target='http://www.example.com'/>
                   </p>
                 </li>
                 <li>
                   <p id='_'>
                     <xref target='_'/>
                   </p>
                 </li>
               </ol>
      </description>
      </requirement>
             </sections>
             </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes permission" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[ABC]]
      [.permission,tag=X,multilingual-rendering=common,class=provision]
      ====
      I recommend this
      ====
    INPUT
    output = <<~"OUTPUT"
                  #{BLANK_HDR}
             <sections>
        <permission id="_" anchor="ABC" tag='X' multilingual-rendering='common' model="default" class="provision">
        <description><p id="_">I recommend this</p></description>
      </permission>
             </sections>
             </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes nested permissions" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      [.permission]
      ====
      I permit this

      =====
      Example 2
      =====

      [.permission]
      =====
      I also permit this

      . List
      . List
      =====

      [requirement,type="general",identifier="/req/core/quantities-uom"]
      ======
      ======
      ====
    INPUT
    output = <<~"OUTPUT"
      #{BLANK_HDR}
             <sections>
               <permission id="_" model="default"><description><p id="_">I permit this</p>
      <example id="_">
        <p id="_">Example 2</p>
      </example></description>
      <permission id="_" model="default">
        <description><p id="_">I also permit this</p>
                  <ol id='_' type='arabic'>
            <li>
              <p id='_'>List</p>
            </li>
            <li>
              <p id='_'>List</p>
            </li>
          </ol>
        </description>
      </permission>
      <requirement id='_' type='general' model="default">
      <identifier>/req/core/quantities-uom</identifier>
      </requirement>
      </permission>
      </sections>
      </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes recommendation with internal markup of structure" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[ABC]]
      [.recommendation,identifier="/ogc/recommendation/wfs/2",subject="user",classification="control-class:Technical;priority:P0;family:System &amp; Communications Protection,System and Communications Protocols",obligation="permission,recommendation",filename="reqt1.rq"]
      ====
      I recommend _this_.

      [.specification,type="tabular",keep-with-next=true,keep-lines-together=true]
      --
      This is the object of the recommendation:
      |===
      |Object |Value
      |Mission | Accomplished
      |===
      --

      As for the measurement targets,

      [.measurement-target]
      --
      The measurement target shall be measured as:
      [stem]
      ++++
      r/1 = 0
      ++++
      --

      [.verification]
      --
      The following code will be run for verification:

      [source,CoreRoot]
      ----
      CoreRoot(success): HttpResponse
      if (success)
        recommendation(label: success-response)
      end
      ----
      --

      [.import%exclude]
      --
      [source,CoreRoot]
      ----
      success-response()
      ----
      --

      [.component]
      --
      Hello
      --

      [.component,class=condition]
      --
      If this be thus
      --
      ====
    INPUT
    output = <<~"OUTPUT"
         #{BLANK_HDR}
          <sections>
             <recommendation id="_" anchor="ABC" model="default" obligation="permission,recommendation" filename="reqt1.rq">
                <identifier>/ogc/recommendation/wfs/2</identifier>
                <subject>user</subject>
                <classification>
                   <tag>control-class</tag>
                   <value>Technical</value>
                </classification>
                <classification>
                   <tag>priority</tag>
                   <value>P0</value>
                </classification>
                <classification>
                   <tag>family</tag>
                   <value>System  Communications Protection</value>
                </classification>
                <classification>
                   <tag>family</tag>
                   <value>System and Communications Protocols</value>
                </classification>
                <description>
                   <p id="_">
                      I recommend
                      <em>this</em>
                      .
                   </p>
                </description>
                <specification keep-with-next="true" keep-lines-together="true" exclude="false" type="tabular">
                   <p id="_">This is the object of the recommendation:</p>
                   <table id="_">
                      <tbody>
                         <tr>
                            <td id="_" valign="top" align="left">Object</td>
                            <td id="_" valign="top" align="left">Value</td>
                         </tr>
                         <tr>
                            <td id="_" valign="top" align="left">Mission</td>
                            <td id="_" valign="top" align="left">Accomplished</td>
                         </tr>
                      </tbody>
                   </table>
                </specification>
                <description>
                   <p id="_">As for the measurement targets,</p>
                </description>
                <measurement-target exclude="false">
                   <p id="_">The measurement target shall be measured as:</p>
                   <formula id="_">
                      <stem block="true" type="MathML">
                         <math xmlns="http://www.w3.org/1998/Math/MathML">
                            <mstyle displaystyle="true">
                               <mfrac>
                                  <mi>r</mi>
                                  <mn>1</mn>
                               </mfrac>
                               <mo>=</mo>
                               <mn>0</mn>
                            </mstyle>
                         </math>
                         <asciimath>r/1 = 0</asciimath>
                      </stem>
                   </formula>
                </measurement-target>
                <verification exclude="false">
                   <p id="_">The following code will be run for verification:</p>
                   <sourcecode id="_" lang="CoreRoot">
                      <body>CoreRoot(success): HttpResponse
       if (success)
         recommendation(label: success-response)
       end</body>
                   </sourcecode>
                </verification>
                <import exclude="true">
                   <sourcecode id="_" lang="CoreRoot">
                      <body>success-response()</body>
                   </sourcecode>
                </import>
                <component exclude="false" class="component">
                   <p id="_">Hello</p>
                </component>
                <component exclude="false" class="condition">
                   <p id="_">If this be thus</p>
                </component>
             </recommendation>
          </sections>
       </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
