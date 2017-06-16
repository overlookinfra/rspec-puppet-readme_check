RSpec::Matchers.define :have_standard_sections do
  match do |readme|
    readme.has_standard_sections?
  end

  failure_message do |readme|
    #TODO Finish messaging
    "expected that #{readme.path} would have all of the standard README sections, but some were missing:\n" +
    ""
  end
end

