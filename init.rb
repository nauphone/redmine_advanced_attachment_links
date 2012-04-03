require 'redmine'
require 'dispatcher'

require 'application_helper'
require 'application_helper_patch'

Dispatcher.to_prepare do
  ApplicationHelper.send :include, ApplicationHelperPatch
end

Redmine::Plugin.register :redmine_advanced_attachment_links do
  name 'Redmine Advanced Attachment Links plugin'
  author '--'
  description 'Allows to create link to attachments in other issue/document'
  version '0.0.1'
  url '--'
  author_url '--'
end
