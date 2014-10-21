Irc.register "Changeset" do |changeset|

  issue = changeset.issues.first

  buf = "New changeset"
  buf << " by #{changeset.user.login.titleize}" if not changeset.user.nil?
  buf << " for issue \"#{issue.subject}\" in #{issue.project.name}" if not issue.nil?

  Irc.say buf

  changeset.comments.split("\n").each do |line|
    Irc.say "   » #{line.gsub('#', '')}"
  end

  Irc.say "   » #{Irc.url(issue.event_url)}" if not issue.nil?
  Irc.say "   » #{Irc.url(changeset.event_url)}"
end

Irc.register "Issue" do |issue|

  buf = "New issue"
  buf << " by #{issue.author.login.titleize}" if not issue.author.nil?
  buf << " for #{issue.assigned_to.login.titleize}" if not issue.assigned_to.nil?
  buf << " in #{issue.project.name}"

  Irc.say buf
  Irc.say "   » #{issue.subject}"
  Irc.say "   » #{Irc.url(issue.event_url)}"

end
