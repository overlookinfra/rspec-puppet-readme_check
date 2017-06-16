require 'json'

module RSpec::Puppet::ReadmeCheck
  class Render < Redcarpet::Render::Base
    # TODO:
    # - Add manifest introspection for parameters
    # - Do we really want hash keys?
    # - Error on duplicate keys
    # - Define a spec which they should adhere to (Check against rendered structure)

    attr_accessor :last_header
    attr_accessor :last_level

    def initialize
      @last_header = '[]'
      @last_level = 0
      super
    end

    def header(text, header_level)
      last_headers = JSON.parse(@last_header)

      last_headers = last_headers[0, header_level - 1]
      last_headers[header_level - 1] = text

      @last_level = header_level
      @last_header = last_headers.to_json

      [ @last_header, header_level ].to_json
    end

    def postprocess(full_document)
      #fd = full_document.dup
      #fd.gsub!('}{', ',')
      #fd.gsub!('[\"', '')
      #fd.gsub!('\"]', '')
      #fd.gsub!('\",\"', ':')
      #fd.gsub!('null', '<missing>')
      fd = "[#{full_document}]"
      fd.gsub!('][', '],[')
    end
  end
end
