RSpec::Matchers.define :have_standard_sections do
  match do |readme|
    readme.missing_standard_sections.empty?
  end

  failure_message do |readme|
    "expected that #{readme.path} would have all of the standard README sections, but some were missing:\n" +
    readme.missing_standard_sections.collect do |section|
      "  - " + section.join(" / ")
    end.join("\n")
  end
end

