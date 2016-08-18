module Pressroom
  class Changelog
    class Change < Struct.new(:text, :issue_number, :issue_url)
    end

    class ChangeGroup < Struct.new(:id, :title)
      attr_reader :changes

      def initialize(*args)
        super(*args)
        @changes = []
      end

      def add_change(text:, issue_number:, issue_url:)
        change = Change.new(text, issue_number, issue_url)
        changes.push(change)
        change
      end
    end

    attr_reader :groups
    attr_accessor :diff_text, :diff_url, :empty_text

    def self.create(sha:, tag: "")
      CreateChangelog.call(sha: sha, tag: tag)
    end

    def initialize
      @groups = []
      @empty_text = "Без существенных изменений."
    end

    def has_diff?
      !diff_text.to_s.empty? && !diff_url.to_s.empty?
    end

    def empty?
      groups.empty?
    end

    def get_group(id:)
      groups.find { |g| g.id == id }
    end

    def add_group(id:, title:)
      group = get_group(id: id)
      if group.nil?
        group = ChangeGroup.new(id, title)
        groups.push(group)
      end
      group
    end

    def to_markdown
      ConvertChangelogToMarkdown.call(changelog: self)
    end
  end
end
