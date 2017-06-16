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

  def missing_documented_parameters_for(manifest_name)
    split_name = manifest_name.split("::")
    if split_name.length == 1
    else
      get_parameters_from(manifest_name).collect do |param_name|
        expected_section = [[
          module_name,
          "Reference",
          "Public defined types",
          "Defined type: `#{manifest_name}`",
          "`#{param_name}`",
        ]]
        param_name unless (expected_section - readme_sections).empty?
      end.compact
    end
  end

  private

  def readme_sections
    readme_structure.collect { |x| x.first }
  end

  def module_name
    readme_structure.find do |section, heading|
      heading == 1
    end.first.first
  end

  def get_parameters_from(manifest_name)
    require 'puppet-lint'
    linter = PuppetLint.new
    split_name = manifest_name.split("::")
    if split_name.length == 1
      path = "manifests/init.pp"
    else
      path = "manifests/#{split_name[1..-1].join("/")}.pp"
    end
    linter.file = path
    linter.run
    lexer = PuppetLint::Lexer.new
    PuppetLint::Data.path = linter.path
    PuppetLint::Data.manifest_lines = linter.code.split("\n", -1)
    PuppetLint::Data.tokens = lexer.tokenise(linter.code)
    class_idxs = (PuppetLint::Data.class_indexes + PuppetLint::Data.defined_type_indexes)
    variable_list = class_idxs.collect do |class_idx|
      (class_idx[:param_tokens] || []).collect do |token|
        token if (
          token.type == :VARIABLE and (
            (
              token.prev_code_token.nil? or [:LPAREN, :COMMA].include?(token.prev_code_token.type)
            ) and (
              token.next_code_token.type == :COMMA or token.next_code_token.type == :EQUALS
            )
          )
        )
      end
    end.flatten.compact.collect do |variable_token|
      variable_token.value
    end
  end
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
