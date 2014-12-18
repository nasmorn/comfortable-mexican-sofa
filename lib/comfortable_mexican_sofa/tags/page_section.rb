class ComfortableMexicanSofa::Tag::PageSection
  include ComfortableMexicanSofa::Tag
  
  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):section:?(.*?)\s*\}\}/
  end

  def sub_pages
    blockable.children.select {|child| child.slug.split("-").first == "section" && child.slug.gsub("section-","") =~ Regexp.new('\A' + identifier.dasherize)}
  end
  
  def content
    sub_pages.collect(&:render).join
  end
  
  def render
    content
  end
  
end