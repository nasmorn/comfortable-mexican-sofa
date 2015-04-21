module ComfortableMexicanSofa::Fixture::Section
  class Importer < ComfortableMexicanSofa::Fixture::Importer

    attr_accessor :target_pages

    def import!(path = self.path, parent = nil)
      Dir["#{path}*/"].each do |path|
        slug = path.split('/').last

        page = if parent
          parent.children.where(:slug => slug).first || site.pages.new(:parent => parent, :slug => slug)
        else
          site.pages.root || site.pages.new(:slug => slug)
        end

        # setting attributes
        categories = []
        if File.exists?(attrs_path = File.join(path, 'attributes.yml'))
          if fresh_fixture?(page, attrs_path)
            attrs = get_attributes(attrs_path)

            page.label        = attrs['label']
            page.layout       = site.layouts.find_by(:identifier => attrs['layout']) || parent.try(:layout)
            page.is_published = attrs['is_published'].nil?? true : attrs['is_published']
            page.position     = attrs['position'] if attrs['position']

            categories        = attrs['categories']

            if attrs['target_page']
              self.target_pages ||= {}
              self.target_pages[page] = attrs['target_page']
            end
          end
        end

        # setting content
        blocks_to_clear = page.blocks.collect(&:identifier)
        blocks_attributes = [ ]
        file_extentions = %w(html haml jpg png gif)
        Dir.glob("#{path}/*.{#{file_extentions.join(',')}}").each do |block_path|
          extention = File.extname(block_path)[1..-1]
          identifier = block_path.split('/').last.gsub(/\.(#{file_extentions.join('|')})\z/, '')
          blocks_to_clear.delete(identifier)
          if fresh_fixture?(page, block_path)
            content = case extention
            when 'jpg', 'png', 'gif'
              ::File.open(block_path)
            when 'haml'
              Haml::Engine.new(::File.open(block_path).read).render.rstrip
            else
              ::File.open(block_path).read
            end

            blocks_attributes << {
              :identifier => identifier,
              :content    => content
            }
          end
        end

        # deleting removed blocks
        page.blocks.where(:identifier => blocks_to_clear).destroy_all

        page.blocks_attributes = blocks_attributes if blocks_attributes.present?

        # saving
        if page.changed? || page.blocks_attributes_changed || self.force_import
          if page.save
            save_categorizations!(page, categories)
            ComfortableMexicanSofa.logger.info("[FIXTURES] Imported Page \t #{page.full_path}")
          else
            ComfortableMexicanSofa.logger.warn("[FIXTURES] Failed to import Page \n#{page.errors.inspect}")
          end
        end

        self.fixture_ids << page.id

        # importing child pages
        import!(path, page)
      end

      # linking up target pages
      if self.target_pages.present?
        self.target_pages.each do |page, target|
          if target_page = self.site.pages.where(:full_path => target).first
            page.target_page = target_page
            page.save
          end
        end
      end

      # cleaning up
      unless parent
        self.site.pages.where('id NOT IN (?)', self.fixture_ids).each{ |s| s.destroy }
      end
    end
  end

  class Exporter < ComfortableMexicanSofa::Fixture::Exporter

    def export!
      prepare_folder!(self.path)
      
      self.site.pages.map(&:sections).flatten.each do |section|
        section_path = File.join(self.path, section.page.ancestors.reverse.collect{|p| p.slug.blank?? 'index' : p.slug}, section.page.slug, section.tag_identifier + section.position.to_s)
        FileUtils.mkdir_p(section_path)
        
        # writing attributes
        open(File.join(section_path, 'attributes.yml'), 'w') do |f|
          f.write({
            'layout'      => section.layout.try(:identifier),
            'page'        => (section.page.slug.present?? section.page.slug : 'index'),
            'tag_identifier' => section.tag_identifier,
            'is_published'  => section.is_published,
            'position'      => section.position            
          }.to_yaml)
        end
        
        # writing content
        section.blocks_attributes.each do |block|
          open(File.join(section_path, "#{block[:identifier]}.html"), 'w') do |f|
            f.write(block[:content])
          end
        end
        
        ComfortableMexicanSofa.logger.info("[FIXTURES] Exported Section \t #{section_path}")
      end
    end    

  end
end
