require "rake"

module Pressroom
  class Tasks
    def install
      load "pressroom/tasks.rake"
    end
  end
end

Pressroom::Tasks.new.install
