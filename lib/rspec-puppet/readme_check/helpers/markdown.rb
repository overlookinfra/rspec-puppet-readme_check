class RSpec::Puppet::ReadmeCheck::Helpers::Markdown

  attr_reader :path

  def initialize(file_path)
    @path = file_path
    @readme_structure_cache = nil
  end

  def to_s
    "Readme: #{@path}"
  end

  def missing_standard_sections
    module_name = readme_structure.find do |section, heading|
      heading == 1
    end.first.first
    standard_sections = [
      [module_name],
      [module_name, nil, nil, "Table of Contents"],
      [module_name, "Description"],
      [module_name, "Setup"],
      [module_name, "Setup", "Setup Requirements"],
      [module_name, "Setup", "Beginning with #{module_name}"],
      [module_name, "Usage"],
      [module_name, "Reference"],
      [module_name, "Limitations"],
      [module_name, "Development"],
    ]
    readme_sections = readme_structure.collect { |x| x.first }
    standard_sections - readme_sections
  end

  def find_duplicate_sections
    Hash[
      readme_structure.group_by do |section|
        section
      end.map do |section, grouped|
        [section, grouped.count]
      end
    ].collect do |section, count|
      if count > 1
        section[0]
      else
        nil
      end
    end.compact
  end

  private

  def readme_structure
    @readme_structure_cache ||= get_readme_sections
  end

  def get_readme_sections
    markdown = ::Redcarpet::Markdown.new(RSpec::Puppet::ReadmeCheck::Render)
    json = markdown.render(File.read(path))
    begin
      JSON.parse(json).collect do |ary|
        [JSON.parse(ary[0]), ary[1]]
      end
    rescue JSON::ParserError => e
      raise RSpec::Error, "Malformed readme? #{e.message}"
    end
  end
end
