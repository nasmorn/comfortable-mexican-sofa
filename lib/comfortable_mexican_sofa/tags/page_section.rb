class ComfortableMexicanSofa::Tag::PageSection
  include ComfortableMexicanSofa::Tag
  
  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):section:?(.*?)\s*\}\}/
  end

  def sub_pages
    blockable.sections.select {|child| child.tag_identifier == identifier}
  end

  def layouts
    if self.params[0]
      self.params[0].split(" ")
    else
      []
    end
  end
  
  def content
    sub_pages.collect(&:render).join
  end
  
  def render
    content
  end
  
end