Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil

gem "isodoc", github: "metanorma/isodoc", branch: "main"
gem "isodoc-i18n", github: "metanorma/isodoc-i18n", branch: "main"
# released standoc still caps relaton-cli ~> 2.1.0; isodoc main's
# relaton-cli floor is the 3.x pre monogem — resolve standoc from main
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main" # standoc main needs SvgmapElement (> 0.2.13)
