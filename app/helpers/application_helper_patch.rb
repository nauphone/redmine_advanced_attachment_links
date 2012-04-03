require_dependency 'application_helper'

module ApplicationHelperPatch
  def self.included base
    base.class_eval do
      alias :original_parse_redmine_links :parse_redmine_links

      def parse_redmine_links(text, project, obj, attr, only_path, options)
        advanced_parse_redmine_links(text, project, obj, attr, only_path, options)
        original_parse_redmine_links(text, project, obj, attr, only_path, options)
      end

      def advanced_parse_redmine_links(text, project, obj, attr, only_path, options)
        text.gsub!(%r{([^\w\d])?(document|issue)((?:|#)([^"\s<>][^\s<>]*?|"[^"]+?"))((:(?:attachment|attach|file):)([^\s<>^:]+))}) do |m|
          leading, prefix, identifer, attachment = $1, $2, $4, $7
          owner = nil
          if identifer.match(/(#)?(\d+)/)
            id = $2
            case prefix
            when 'document'
              owner = Document.visible.find_by_id(id)
            when 'issue'
              owner = Issue.visible.find_by_id(id)
            end
          elsif identifer.match(/(")?([^\"]*)(")?/)
            title = $2
            case prefix
            when 'document'
              owner = Document.visible.find_by_title(title)
            when 'issue'
              owner = Issue.visible.find_by_title(title)
            end
          end
          unless owner.nil?
            attach = owner.attachments.detect { |a| a.filename == attachment}
            if attach
              link = link_to h(attach.filename), {:only_path => only_path, :controller => 'attachments', :action => 'download', :id => attach},
                                                      :class => 'attachment'
            end
          end
          link ? leading + link : m
        end
      end
    end
  end
end
