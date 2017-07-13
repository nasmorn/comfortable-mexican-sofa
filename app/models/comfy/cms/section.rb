# encoding: utf-8

class Comfy::Cms::Section < ActiveRecord::Base
  self.table_name = 'comfy_cms_sections'

  cms_is_categorized
  cms_manageable

  # -- Relationships --------------------------------------------------------
  belongs_to :page, :touch => true
  belongs_to :layout

  # -- Callbacks ------------------------------------------------------------

  # -- Validations ----------------------------------------------------------
  validates :page_id,
    :presence   => true
  validates :layout,
    :presence   => true
  validates :position,
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


end
