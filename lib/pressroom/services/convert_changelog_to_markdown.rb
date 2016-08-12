module Pressroom
  class ConvertChangelogToMarkdown
    include Service

    def initialize(changelog:)
      @changelog = changelog
    end

    def call
      markdown = ""
      if changelog.empty?
        markdown += changelog.empty_text
      else
        if changelog.has_diff?
          markdown += "[#{changelog.diff_text}](#{changelog.diff_url})\n\n"
        end
        changelog.groups.each do |group|
          markdown += "#{group.title}\n\n"
          group.changes.each do |change|
            markdown += "- [##{change.issue_number}](#{change.issue_url})"
            markdown += " #{change.text}\n"
          end
          markdown += "\n"
        end
      end
      markdown
    end

    private

    attr_reader :changelog
  end
end
