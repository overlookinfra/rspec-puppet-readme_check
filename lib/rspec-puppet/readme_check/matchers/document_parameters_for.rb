RSpec::Matchers.define :document_parameters_for do |manifest_name|
  #TODO Not functioning
  match do |file_path|
    markdown = Redcarpet::Markdown.new(RSpec::Puppet::ReadmeCheck::Render)
    json = JSON.parse(markdown.render(File.read(file_path)))
  end
end

