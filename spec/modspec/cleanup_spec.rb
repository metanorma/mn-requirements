require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Requirements::Modspec do
  it "uses component types specific to Modspec" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[A]]
      [requirement,model=ogc]
      ====
      [[B]]
      [.component,class=Test method type]
      --
      Manual Inspection
      --

      [[C]]
      [.component,class=Test method]
      --
      Step #2
      --

      [[D]]
      [component,class=step]
      --
      Step
      --

      [[E]]
      [component,class=guidance]
      --
      Guidance
      --
      ====
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
         <sections>
           <requirement id='A' model='ogc'>
             <component exclude='false' class='Test method type'>
               <p id='_'>Manual Inspection</p>
             </component>
             <component exclude='false' class='Test method'>
               <p id='_'>Step #2</p>
             </component>
             <component exclude='false' class='step'>
               <p id='_'>Step</p>
             </component>
             <component exclude='false' class='guidance'>
               <p id='_'>Guidance</p>
             </component>
           </requirement>
         </sections>
       </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "extends requirement dl syntax" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[id1]]
      [requirement,model=ogc]
      ====
      [%metadata]
      type:: class
      identifier:: \\http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules
      subject:: Encoding of logical models
      inherit:: urn:iso:dis:iso:19156:clause:7.2.2
      inherit:: urn:iso:dis:iso:19156:clause:8
      inherit:: http://www.opengis.net/doc/IS/GML/3.2/clause/2.4
      inherit:: O&M Abstract model, OGC 10-004r3, clause D.3.4
      inherit:: http://www.opengis.net/spec/SWE/2.0/req/core/core-concepts-used
      inherit:: <<ref2>>
      inherit:: <<ref3>>
      classification:: priority:P0
      classification:: domain:Hydrology,Groundwater
      classification:: control-class:Technical
      obligation:: recommendation,requirement
      conditions::
      . Candidate test subject is a witch
      . Widget has been suitably calibrated for aerodynamics
      part:: Determine travel distance by flight path
      guidance:: Guidance
      description:: Interpolated description
      scope::: random
      widgets::: randomer
      recommendation:: /label/1
      part:: Widget has been suitably calibrated for aerodynamics
      test-method:: Method
      description::: Method description
      step::: Step 1
      step:::: Step 2
      statement:: Statement
      test-purpose:: Purpose
      test-method-type:: Method Type
      reference:: <<ref2>>
      step:: Step
      Test Method:: Method2
      Test Purpose:: Purpose2
      Test Method Type:: Method Type2
      target:: http://www.example.com
      indirect-dependency:: http://www.example.com
      Indirect-dependency:: <<ref3>>
      conformance-class:: A1
      conformance-test:: A2
      abstract-test:: A3
      requirement-class:: A4
      recommendation-class:: A5
      permission-class:: A6
      implements:: A7
      Implements:: A8
      identifier-base:: IDENT
      identifier-base:: http://www.example.com
      statement:: ABC
      +
      --
      * D
      * E
      * F
      --

      Logical models encoded as XSDs should be faithful to the original UML conceptual
      models.
      ====
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR.sub(/<metanorma-extension>/, <<~EXT
         <metanorma-extension>
           <table id='_'>
             <tbody>
               <tr>
                 <th>id1</th>
                 <td>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</td>
               </tr>
                      <tr>
          <th>_</th>
          <td>/label/1</td>
        </tr>
        <tr>
          <th>_</th>
          <td>A1</td>
        </tr>
        <tr>
          <th>_</th>
          <td>A2</td>
        </tr>
        <tr>
          <th>_</th>
          <td>A3</td>
        </tr>
        <tr>
          <th>_</th>
          <td>A4</td>
        </tr>
        <tr>
          <th>_</th>
          <td>A5</td>
        </tr>
        <tr>
          <th>_</th>
          <td>A6</td>
        </tr>
             </tbody>
           </table>
      EXT
      )}
               <sections>
           <requirement id='id1' model='ogc' obligation='recommendation,requirement' type='class'>
             <identifier>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</identifier>
             <subject>Encoding of logical models</subject>
             <inherit>urn:iso:dis:iso:19156:clause:7.2.2</inherit>
             <inherit>urn:iso:dis:iso:19156:clause:8</inherit>
             <inherit>http://www.opengis.net/doc/IS/GML/3.2/clause/2.4</inherit>
             <inherit>O&amp;M Abstract model, OGC 10-004r3, clause D.3.4</inherit>
             <inherit>http://www.opengis.net/spec/SWE/2.0/req/core/core-concepts-used</inherit>
             <inherit>
               <xref target='ref2'/>
             </inherit>
             <inherit>
               <xref target='ref3'/>
             </inherit>
             <classification>
               <tag>priority</tag>
               <value>P0</value>
             </classification>
             <classification>
               <tag>domain</tag>
               <value>Hydrology</value>
             </classification>
             <classification>
               <tag>domain</tag>
               <value>Groundwater</value>
             </classification>
             <classification>
               <tag>control-class</tag>
               <value>Technical</value>
             </classification>
             <classification>
               <tag>Test Method</tag>
               <value>Method2</value>
             </classification>
             <classification>
               <tag>Test Purpose</tag>
               <value>Purpose2</value>
             </classification>
             <classification>
               <tag>Test Method Type</tag>
               <value>Method Type2</value>
             </classification>
             <classification>
               <tag>target</tag>
               <value>http://www.example.com</value>
             </classification>
             <classification>
               <tag>indirect-dependency</tag>
               <value>http://www.example.com</value>
             </classification>
             <classification>
               <tag>Indirect-dependency</tag>
               <value>
                 <xref target='ref3'/>
               </value>
             </classification>
             <classification>
               <tag>implements</tag>
               <value>A7</value>
             </classification>
             <classification>
               <tag>Implements</tag>
               <value>A8</value>
             </classification>
             <classification>
               <tag>identifier-base</tag>
               <value>IDENT</value>
             </classification>
             <classification>
                <tag>identifier-base</tag>
                <value>http://www.example.com</value>
             </classification>
             <component class='conditions'>
               <ol id='_' type='arabic'>
                 <li>
                   <p id='_'>Candidate test subject is a witch</p>
                 </li>
                 <li>
                   <p id='_'>Widget has been suitably calibrated for aerodynamics</p>
                 </li>
               </ol>
             </component>
             <component class='part'>
               <p id='_'>Determine travel distance by flight path</p>
             </component>
             <component class='guidance'>
               <p id='_'>Guidance</p>
             </component>
             <description>
               <p id='_'>Interpolated description</p>
                      <classification>
         <tag>scope</tag>
         <value>random</value>
       </classification>
       <classification>
         <tag>widgets</tag>
         <value>randomer</value>
       </classification>
             </description>
             <recommendation id='_' model='ogc' type='general'>
               <identifier>/label/1</identifier>
             </recommendation>
             <component class='part'>
               <p id='_'>Widget has been suitably calibrated for aerodynamics</p>
             </component>
             <component class='test-method'>
               <p id='_'>Method</p>
               <description>
                 <p id='_'>Method description</p>
               </description>
               <component class='step'>
                 <p id='_'>Step 1</p>
                 <component class='step'>
                   <p id='_'>Step 2</p>
                 </component>
               </component>
             </component>
             <description>
               <p id='_'>Statement</p>
             </description>
             <component class='test-purpose'>
               <p id='_'>Purpose</p>
             </component>
             <component class='test-method-type'>
               <p id='_'>Method Type</p>
             </component>
             <component class='reference'>
               <p id='_'>
                 <xref target='ref2'/>
               </p>
             </component>
             <component class='step'>
               <p id='_'>Step</p>
             </component>
             <component class='test-method'>
               <p id='_'>Method2</p>
             </component>
             <component class='test-purpose'>
               <p id='_'>Purpose2</p>
             </component>
             <component class='test-method-type'>
               <p id='_'>Method Type2</p>
             </component>
             <requirement id='_' model='ogc' type='conformanceclass'>
               <identifier>A1</identifier>
             </requirement>
             <requirement id='_' model='ogc' type='verification'>
               <identifier>A2</identifier>
             </requirement>
             <requirement id='_' model='ogc' type='abstracttest'>
               <identifier>A3</identifier>
             </requirement>
             <requirement id='_' model='ogc' type='class'>
               <identifier>A4</identifier>
             </requirement>
             <recommendation id='_' model='ogc' type='class'>
               <identifier>A5</identifier>
             </recommendation>
             <permission id='_' model='ogc' type='class'>
               <identifier>A6</identifier>
             </permission>
             <description>
               <p id="_">ABC</p>
            <ul id="_">
               <li>
                  <p id="_">D</p>
               </li>
               <li>
                  <p id="_">E</p>
               </li>
               <li>
                  <p id="_">F</p>
               </li>
            </ul>
                 <p id="_">Logical models encoded as XSDs should be faithful to the original UML
                 conceptual models.</p>
               </p>
             </description>
           </requirement>
         </sections>
       </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))
      .gsub(%r{<th>_[^<]+</th>}, "<th>_</th>")))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "deals with live links in requirements dl" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[id1]]
      [requirement,model=ogc]
      ====
      [%metadata]
      type:: class
      identifier:: http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules[]
      subject:: Encoding of logical models
      inherit:: http://www.opengis.net/doc/IS/GML/3.2/clause/2.4[]
      conformance-test:: http://www.opengis.net/doc/IS/GML/3.2/clause/2.4[]
      ====
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR.sub(/<metanorma-extension>/, <<~EXT
        <metanorma-extension>
          <table id='_'>
            <tbody>
              <tr>
                <th>id1</th>
                <td>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</td>
              </tr>
              <tr>
                <th>_</th>
                <td>http://www.opengis.net/doc/IS/GML/3.2/clause/2.4</td>
              </tr>
            </tbody>
          </table>
      EXT
      )}
        <sections>
          <requirement id='id1' model='ogc' type='class'>
            <identifier>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</identifier>
            <subject>Encoding of logical models</subject>
            <inherit>http://www.opengis.net/doc/IS/GML/3.2/clause/2.4</inherit>
            <requirement id='_' model='ogc' type='verification'>
              <identifier>http://www.opengis.net/doc/IS/GML/3.2/clause/2.4</identifier>
            </requirement>
          </requirement>
        </sections>
      </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))
      .gsub(%r{<th>_[^<]+</th>}, "<th>_</th>")))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "deals with unresolved xrefs in requirement" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[id1]]
      [requirement,model=ogc]
      ====
      [%metadata]
      type:: class
      identifier:: http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules[]
      statement:: See <<xyz>>
      ====
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR.sub(/<metanorma-extension>/, <<~EXT
        <metanorma-extension>
          <table id='_'>
            <tbody>
              <tr>
                <th>id1</th>
                <td>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</td>
              </tr>
            </tbody>
          </table>
      EXT
      )}
        <sections>
          <requirement id='id1' model='ogc' type='class'>
            <identifier>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</identifier>
                <description>
                   <p id="_">
                      See
                      <xref target="xyz"/>
                   </p>
                </description>
          </requirement>
        </sections>
      </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))
      .gsub(%r{<th>_[^<]+</th>}, "<th>_</th>")))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "allows nested steps in requirement test methods" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [requirement,model=ogc]
      ====
      [.component,class=Test method type]
      --
      Manual Inspection
      --

      [.component,class=Test method]
      =====

      [.component,class=step]
      ======
      For each UML class defined or referenced in the Tunnel Package:

      [.component,class=step]
      --
      Validate that the Implementation Specification contains a data element which represents the same concept as that defined for the UML class.
      --

      [.component,class=step]
      --
      Validate that the data element has the same relationships with other elements as those defined for the UML class. Validate that those relationships have the same source, target, direction, roles, and multiplicies as those documented in the Conceptual Model.
      --
      ======
      =====
      ====
    INPUT
    output = <<~OUTPUT
                #{BLANK_HDR}
           <sections>
         <requirement id='_' model='ogc'>
           <component exclude='false' class='Test method type'>
             <p id='_'>Manual Inspection</p>
           </component>
           <component exclude='false' class='Test method'>
               <component exclude='false' class='step'>
                 <p id='_'>For each UML class defined or referenced in the Tunnel Package:</p>
                 <component exclude='false' class='step'>
                   <p id='_'>
                     Validate that the Implementation Specification contains a data
                     element which represents the same concept as that defined for
                     the UML class.
                   </p>
                 </component>
                 <component exclude='false' class='step'>
                   <p id='_'>
                     Validate that the data element has the same relationships with
                     other elements as those defined for the UML class. Validate that
                     those relationships have the same source, target, direction,
                     roles, and multiplicies as those documented in the Conceptual
                     Model.
                   </p>
                 </component>
               </component>
           </component>
         </requirement>
       </sections>
      </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "uses ModSpec requirement types" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [.requirement,type=requirement,model=ogc]
      ====
      ====

      [.requirement,type=recommendation,model=ogc]
      ====
      ====

      [.requirement,type=permission,model=ogc]
      ====
      ====

      [.requirement,type=requirements_class,model=ogc]
      ====
      ====

      [.requirement,type=conformance_test,model=ogc]
      ====
      ====

      [.requirement,type=conformance_class,model=ogc]
      ====
      ====

      [.requirement,type=abstract_test,model=ogc]
      ====
      ====

    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
            <sections>
          <requirement id='_' type='general' model="ogc"> </requirement>
          <requirement id='_' type='general' model="ogc"> </requirement>
          <requirement id='_' type='general' model="ogc"> </requirement>
          <requirement id='_' type='class' model="ogc"> </requirement>
          <requirement id='_' type='verification' model="ogc"> </requirement>
          <requirement id='_' type='conformanceclass' model="ogc"> </requirement>
          <requirement id='_' type='abstracttest' model="ogc"> </requirement>
        </sections>
       </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "uses ModSpec requirement style attributes" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [requirements_class,model=ogc]
      ====
      ====

      [conformance_test,model=ogc]
      ====
      ====

      [conformance_class,model=ogc]
      ====
      ====

      [abstract_test,model=ogc]
      ====
      ====

    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
            <sections>
          <requirement id='_' type='class' model="ogc"> </requirement>
          <requirement id='_' type='verification' model="ogc"> </requirement>
          <requirement id='_' type='conformanceclass' model="ogc"> </requirement>
          <requirement id='_' type='abstracttest' model="ogc"> </requirement>
        </sections>
       </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "generates identifier-based anchor for requirement if none supplied" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [requirement,model=ogc]
      ====
      [%metadata]
      type:: class
      identifier:: \\http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules
      ====

      [requirement,model=ogc]
      ====
      [%metadata]
      type:: class
      ====
    INPUT
    output = <<~OUTPUT
      <sections>
        <requirement id="http___www.opengis.net_spec_waterml_2.0_req_xsd-xml-rules" model="ogc" type="class">
          <identifier>http://www.opengis.net/spec/waterml/2.0/req/xsd-xml-rules</identifier>
        </requirement>
        <requirement id="_" model="ogc" type="class"/>
      </sections>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml = xml.at("//xmlns:sections")
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "uses Modspec YAML" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[E]]
      [conformance_test,model=ogc]
      ====
      [source,yaml]
      ----
      name: Verify expression of duration as GeoPose_Duration
      identifier: /conf/series-regular/duration
      targets:
      - /req/series-regular/duration
      dependencies:
      - /conf/time/duration
      description: |
        To confirm that the `Regular_Series.interPoseDuration` attribute is
        represented by an instance of the `GeoPose_Duration` object.
      purpose: To confirm the correct properties of a GeoPose Duration.
      ----
      ====

      [requirement_class,model=ogc]
      ====
      [source,yaml]
      ----
      name: Tangent point height value specification
      identifier: /req/tangent-point/height
      statement: |
          An instance of a GeoPose `tangentPoint.h` attribute SHALL be expressed as
          a height in meters above the WGS-84 ellipsoid, represented as a signed as
          a signed floating point value conforming to IEEE 754. If the tangent point
          is above the WGS-84 ellipsoid, the value SHALL be positive. If the tangent
          point is below the WGS-84 ellipsoid, the value SHALL be negative.
      ----
      ====
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
         <sections>
           <requirement id='A' model='ogc'>
             <component exclude='false' class='Test method type'>
               <p id='_'>Manual Inspection</p>
             </component>
             <component exclude='false' class='Test method'>
               <p id='_'>Step #2</p>
             </component>
             <component exclude='false' class='step'>
               <p id='_'>Step</p>
             </component>
             <component exclude='false' class='guidance'>
               <p id='_'>Guidance</p>
             </component>
           </requirement>
         </sections>
       </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)

    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[E]]
      [conformance_class,model=ogc]
      ====
      [source,yaml]
      ----
      name: Regular_Series logical model SDU conformance
      identifier: /conf/series-regular
      target:
      - /req/series-regular
      classification: "Target Type: SDU"
      description: To confirm that components of a Regular Series conform to the Logical Model.
      dependencies:
      - /conf/global
      - /conf/frame-spec
      - /conf/time

      tests:

      - name: Verify expression of duration as GeoPose_Duration
        identifier: /conf/series-regular/duration
        targets:
        - /req/series-regular/duration
        dependencies:
        - /conf/time/duration
        description: |
          To confirm that the `Regular_Series.interPoseDuration` attribute is
          represented by an instance of the `GeoPose_Duration` object.
        purpose: To confirm the correct properties of a GeoPose Duration.

      - name: Verify expression of outer frame
        identifier: /conf/series-regular/outer-frame
        targets:
        - /req/series-regular/outer-frame
        purpose: |
          The `Regular_Series.outerFrame` attribute shall represent the first frame
          in the series with the `ExplicitFrameSpec` object.

      - name: Verify expression of inner frames
        identifier: /conf/series-regular/inner-frame-series
        targets:
        - /req/series-regular/inner-frame-series
        purpose: |
          The `Regular_Series.innerFrameSeries` attribute shall represent the
          succession of inner frames as an array of `ExplicitFrameSpec` objects.

      - name: Verify expression of series header
        identifier: /conf/series-regular/header
        targets:
        - /req/series-regular/header
        description: |
          Verify that the `Regular_Series.header` attribute is implemented as an
          instance of SeriesHeader.
        purpose: |
          To confirm that the implementation of Series Header conforms to the
          Logical Model.

      - name: Verify expression of series trailer
        identifier: /conf/series-regular/trailer
        targets:
        - /req/series-regular/trailer
        description: |
          Verify that the `Regular_Series.trailer` attribute is implemented as an
          instance of SeriesTrailer.
        purpose: |
          To confirm that the implementation of SeriesTrailer conforms to the
          Logical Model.
      ----
      ====

      [requirement_class,model=ogc]
      ====
      [source,yaml]
      ----
      ---
      name: Tangent point requirements
      identifier: /req/tangent-point
      description: |
        Common tangent point requirements for SDUs that include tangent points.
      guidance: |
        The tangent plane `longitude`, `latitude`, and `h` parameters are
        specified without any conditions or constraints on precision to be used in
        an implementation. Any such constraints would be found as requirements on a
        specific implementation as an encoding.

      normative_statements:

      - name: Tangent point height value specification
        identifier: /req/tangent-point/height
        statement: |
          An instance of a GeoPose `tangentPoint.h` attribute SHALL be expressed as
          a height in meters above the WGS-84 ellipsoid, represented as a signed as
          a signed floating point value conforming to IEEE 754. If the tangent point
          is above the WGS-84 ellipsoid, the value SHALL be positive. If the tangent
          point is below the WGS-84 ellipsoid, the value SHALL be negative.

      - name: Tangent point latitude value specification
        identifier: /req/tangent-point/latitude
        statement: |
          An instance of GeoPose tangentPoint.latitude attribute SHALL be expressed
          as decimal degrees and represented as a signed floating point
          value conforming to IEEE 754.. The minimum value shall be 90.0 degrees
          and the maximum value shall be 90.0 degrees.

      - name: Tangent point longitude value specification
        identifier: /req/tangent-point/longitude
        statement: |
          An instance of a GeoPose tangentPoint.longitude attribute SHALL be
          expressed as decimal degrees and represented as a signed floating point
          value conforming to IEEE 754. The minimum value shall be -180.0 degrees
          and the maximum value shall be 180.0 degrees.
      ----
      ====

    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
         <sections>
           <requirement id='A' model='ogc'>
             <component exclude='false' class='Test method type'>
               <p id='_'>Manual Inspection</p>
             </component>
             <component exclude='false' class='Test method'>
               <p id='_'>Step #2</p>
             </component>
             <component exclude='false' class='step'>
               <p id='_'>Step</p>
             </component>
             <component exclude='false' class='guidance'>
               <p id='_'>Guidance</p>
             </component>
           </requirement>
         </sections>
       </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "uses Modspec YAML for suites" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[E]]
      [conformance_class,model=ogc]
      ====
      [source,yaml]
      ----
      conformance_classes:
      - name: Regular_Series logical model SDU conformance
        identifier: /conf/series-regular
        target:
        - /req/series-regular
        classification: "Target Type: SDU"
        description: To confirm that components of a Regular Series conform to the Logical Model.
        dependencies:
        - /conf/global
        - /conf/frame-spec
        - /conf/time

        tests:

        - name: Verify expression of duration as GeoPose_Duration
          identifier: /conf/series-regular/duration
          targets:
          - /req/series-regular/duration
          dependencies:
          - /conf/time/duration
          description: |
            To confirm that the `Regular_Series.interPoseDuration` attribute is
            represented by an instance of the `GeoPose_Duration` object.
          purpose: To confirm the correct properties of a GeoPose Duration.

        - name: Verify expression of outer frame
          identifier: /conf/series-regular/outer-frame
          targets:
          - /req/series-regular/outer-frame
          purpose: |
            The `Regular_Series.outerFrame` attribute shall represent the first frame
            in the series with the `ExplicitFrameSpec` object.

        - name: Verify expression of inner frames
          identifier: /conf/series-regular/inner-frame-series
          targets:
          - /req/series-regular/inner-frame-series
          purpose: |
            The `Regular_Series.innerFrameSeries` attribute shall represent the
            succession of inner frames as an array of `ExplicitFrameSpec` objects.

        - name: Verify expression of series header
          identifier: /conf/series-regular/header
          targets:
          - /req/series-regular/header
          description: |
            Verify that the `Regular_Series.header` attribute is implemented as an
            instance of SeriesHeader.
          purpose: |
            To confirm that the implementation of Series Header conforms to the
            Logical Model.

        - name: Verify expression of series trailer
          identifier: /conf/series-regular/trailer
          targets:
          - /req/series-regular/trailer
          description: |
            Verify that the `Regular_Series.trailer` attribute is implemented as an
            instance of SeriesTrailer.
          purpose: |
            To confirm that the implementation of SeriesTrailer conforms to the
            Logical Model.
      ----
      ====

      [requirement_class,model=ogc]
      ====
      [source,yaml]
      ----
      ---
      normative_statements_classes:
      - name: Tangent point requirements
        identifier: /req/tangent-point
        description: |
          Common tangent point requirements for SDUs that include tangent points.
        guidance: |
          The tangent plane `longitude`, `latitude`, and `h` parameters are
          specified without any conditions or constraints on precision to be used in
          an implementation. Any such constraints would be found as requirements on a
          specific implementation as an encoding.

        normative_statements:

        - name: Tangent point height value specification
          identifier: /req/tangent-point/height
          statement: |
            An instance of a GeoPose `tangentPoint.h` attribute SHALL be expressed as
            a height in meters above the WGS-84 ellipsoid, represented as a signed as
            a signed floating point value conforming to IEEE 754. If the tangent point
            is above the WGS-84 ellipsoid, the value SHALL be positive. If the tangent
            point is below the WGS-84 ellipsoid, the value SHALL be negative.

        - name: Tangent point latitude value specification
          identifier: /req/tangent-point/latitude
          statement: |
            An instance of GeoPose tangentPoint.latitude attribute SHALL be expressed
            as decimal degrees and represented as a signed floating point
            value conforming to IEEE 754.. The minimum value shall be 90.0 degrees
            and the maximum value shall be 90.0 degrees.

        - name: Tangent point longitude value specification
          identifier: /req/tangent-point/longitude
          statement: |
            An instance of a GeoPose tangentPoint.longitude attribute SHALL be
            expressed as decimal degrees and represented as a signed floating point
            value conforming to IEEE 754. The minimum value shall be -180.0 degrees
            and the maximum value shall be 180.0 degrees.
      ----
      ====

    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
         <sections>
           <requirement id='A' model='ogc'>
             <component exclude='false' class='Test method type'>
               <p id='_'>Manual Inspection</p>
             </component>
             <component exclude='false' class='Test method'>
               <p id='_'>Step #2</p>
             </component>
             <component exclude='false' class='step'>
               <p id='_'>Step</p>
             </component>
             <component exclude='false' class='guidance'>
               <p id='_'>Guidance</p>
             </component>
           </requirement>
         </sections>
       </standard-document>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
