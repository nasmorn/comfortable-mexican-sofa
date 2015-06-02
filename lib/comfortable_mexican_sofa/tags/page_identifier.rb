class ComfortableMexicanSofa::Tag::PageIdentifier
  include ComfortableMexicanSofa::Tag
  
  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:identifier:(#{identifier})\s*\}\}/
  end
  
  def content
    nil
  end

  def render
    block.blockable.identifier
  end
  
end