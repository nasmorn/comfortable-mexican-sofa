require 'active_support/concern'

module Comfy::Cms::PageSections
  extend ActiveSupport::Concern

  included do 
    has_many :sections, inverse_of: :page
    accepts_nested_attributes_for :sections, allow_destroy: true
  end

  # class_methods do
  # end
end