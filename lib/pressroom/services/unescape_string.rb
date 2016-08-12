module Pressroom
  class UnescapeString
    include Service

    def initialize(string)
      @string = string.to_s
    end

    def call
      string.gsub(/\\u([\da-fA-F]{4})/) do
        [$1].pack("H*").unpack("n*").pack("U*")
      end
    end

    private

    attr_reader :string
  end
end
