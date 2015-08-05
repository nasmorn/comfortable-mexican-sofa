class ComfortableMexicanSofa::Tag::FieldComment
  include ComfortableMexicanSofa::Tag
  
  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:field:(#{identifier}):comment:?(.*?)\s*\}\}/
  end

  def comment
    self.params[0]
  end

  def content
    block.content
  end
  
  def render
    ''
  end
  
end