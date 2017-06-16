class RSpec::Puppet::ReadmeCheck::Helpers::Readme

  attr_reader :path

  def initialize(file_path)
    @path = file_path
    @readme_structure_cache = nil
  end

  def to_s
    "Readme: #{@path}"
  end

  def has_standard_sections?
    #TODO fill out the standard sections
    (readme_structure.to_a - { 'java' => 1 }.to_a).empty?
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
