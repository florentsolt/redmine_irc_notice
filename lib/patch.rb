module IrcModelPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      after_create :irc
    end
  end

  module InstanceMethods
    def irc
      Irc.notice(self)
    end
  end
end

require_dependency "issue"
Issue.send(:include, IrcModelPatch)

require_dependency "changeset"
Changeset.send(:include, IrcModelPatch)