class ComfortableMexicanSofa::Tag::PageSection
  include ComfortableMexicanSofa::Tag
  
  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):section:?(.*?)\s*\}\}/
  end
  
  def content
    block.content
  end
  
  def render
    "SECTION"
  end
  
end