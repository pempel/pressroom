require "github_changelog_generator"

module Pressroom
  class GenerateChangelog
    include Service

    def initialize(tag_from: "", tag_to: "")
      @tag_from = tag_from.to_s
      @tag_to = tag_to.to_s
    end

    def call
      options = GitHubChangelogGenerator::Parser.default_options
      options[:user] = Pressroom.configuration.github_user
      options[:project] = Pressroom.configuration.github_repo
      options[:token] = Pressroom.configuration.github_token
      options[:pulls] = false
      options[:verbose] = false
      options[:bug_prefix] = bug_prefix
      options[:issue_prefix] = issue_prefix
      options[:enhancement_labels] = []

      changelog_generator = GitHubChangelogGenerator::Generator.new(options)
      changelog_generator.define_singleton_method(:generate) do |tag_1, tag_2|
        fetch_and_filter_tags
        sort_tags_by_date(@filtered_tags)
        fetch_issues_and_pr
        filtered_tag_1 = @filtered_tags.find { |t| t.name == tag_1 }
        filtered_tag_2 = @filtered_tags.find { |t| t.name == tag_2 }
        generate_log_between_tags(filtered_tag_1, filtered_tag_2)
      end

      lines = changelog_generator.generate(tag_from, tag_to).split("\n")
      lines = lines.drop_while { |l| l.empty? }
      lines = lines.reverse.drop_while { |l| l.empty? }.reverse

      changelog = Changelog.new

      state = "line"
      lines.each do |line|
        case state
        when "line"
          case
          when line.include?("[Full Changelog]")
            changelog.diff_text = line.scan(/\(.*compare\/(.*)\)/).first.first
            changelog.diff_url = line.scan(/\((.*)\)/).first.first
          when line.include?(bug_prefix)
            changelog.add_group(id: bug_prefix, title: "Исправлены ошибки:")
            state = "bug_prefix"
          when line.include?(issue_prefix)
            changelog.add_group(id: issue_prefix, title: "Реализованы задачи:")
            state = "issue_prefix"
          end
        when "bug_prefix"
          state = "bug"
        when "bug"
          if line.empty?
            state = "line"
          else
           matches = line.scan(/-(.*)\[.*#(.*)\]\((.*)\)/).first
           changelog.get_group(id: bug_prefix).add_change(
             text: matches[0].strip,
             issue_number: matches[1].strip,
             issue_url: matches[2].strip
           )
         end
        when "issue_prefix"
          state = "issue"
        when "issue"
          if line.empty?
            state = "line"
          else
            matches = line.scan(/-(.*)\[.*#(.*)\]\((.*)\)/).first
            changelog.get_group(id: issue_prefix).add_change(
              text: matches[0].strip,
              issue_number: matches[1].strip,
              issue_url: matches[2].strip
            )
          end
        end
      end

      changelog
    end

    private

    attr_reader :tag_from, :tag_to

    def bug_prefix
      "**fixed_bugs**"
    end

    def issue_prefix
      "**closed_issues**"
    end
  end
end
