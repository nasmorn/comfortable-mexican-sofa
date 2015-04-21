# encoding: utf-8

class Comfy::Cms::Section < ActiveRecord::Base
  self.table_name = 'comfy_cms_sections'

  cms_is_categorized
  cms_manageable

  # -- Relationships --------------------------------------------------------
  belongs_to :page
  belongs_to :layout

  # -- Callbacks ------------------------------------------------------------
  before_create     :assign_position

  # -- Validations ----------------------------------------------------------
  validates :page_id,
    :presence   => true
  validates :layout,
    :presence   => true

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_sections.position') }
  scope :published, -> { where(:is_published => true) }

  # -- Class Methods --------------------------------------------------------

  def self.layouts(allowed = [])
    all = Comfy::Cms::Layout.where("identifier LIKE ?", "section-%")
    if allowed.any?
      all.select {|l| allowed.map {|a| "section-" + a}.include? l.identifier}
    else
      all
    end
  end

  # -- Instance Methods -----------------------------------------------------

  def site
    page.site
  end

protected

  def assign_position
    return unless self.page
    return if self.position.to_i > 0
    max = self.page.sections.maximum(:position)
    self.position = max ? max + 1 : 0
  end

end
