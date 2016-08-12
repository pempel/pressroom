module Pressroom
  module Service
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
    end

    module InstanceMethods
      def call
        # Overwrite this method in a service class.
      end
    end

    module ClassMethods
      def call(*args)
        new(*args).call
      end
    end
  end
end
