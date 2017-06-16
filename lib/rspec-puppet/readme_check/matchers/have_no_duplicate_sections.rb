RSpec::Matchers.define :have_no_duplicate_sections do
  match do |readme|
    readme.find_duplicate_sections.empty?
  end

  failure_message do |readme|
    "expected that #{readme.path} would have no duplicate sections, but some were found:\n" +
    readme.find_duplicate_sections.collect do |section|
      "  - " + section.join(" / ")
    end.join("\n")
  end
end

