RSpec::Matchers.define :document_parameters_for do |manifest_name|
  match do |readme|
    readme.missing_documented_parameters_for(manifest_name).empty?
  end

  failure_message do |readme|
    "expected that #{readme.path} would document all parameters for #{manifest_name}, but some are missing:\n" +
    readme.missing_documented_parameters_for(manifest_name).collect do |param|
      "  - " + param
    end.join("\n")
  end
end

