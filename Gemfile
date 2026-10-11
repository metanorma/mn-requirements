Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil

gem "isodoc", github: "metanorma/isodoc", branch: "main"
gem "isodoc-i18n", github: "metanorma/isodoc-i18n", branch: "main"
