Irc.register "Changeset" do |changeset|
  url = Irc.url(changeset.event_url)
  if changeset.user.is_a? User
    user = changeset.user.login.titleize
    Irc.say "#{user} commited r#{changeset.revision} #{url}"
  else
    Irc.say "A new commit r#{changeset.revision} #{url}"
  end
  if not changeset.comments.gsub(/([r#]\d+)|merge|trunk|qa|prod|in|to/i, '').strip.empty?
    changeset.comments.split("\n").each do |line|
      Irc.say "   » #{line.gsub('#', '')}"
    end
  end

  issue = changeset.issues.first
  if not issue.nil?
    project = issue.project.name
    subject = issue.subject
    url = Irc.url(issue.event_url)
    Irc.say "   » For action #{issue.id} #{url} in #{project}"
    Irc.say "   » #{subject}"
  else
    Irc.say "   » Not related to an action or project"
  end
end

Irc.register "Issue" do |issue|
  url = Irc.url(issue.event_url)
  project = issue.project.name
  Irc.say "New action #{issue.id} #{url} in #{project}"
  Irc.say "   » #{issue.subject}"
  if issue.author and issue.assigned_to
    author = issue.author.login.titleize
    assignee = issue.assigned_to.login.titleize
    Irc.say "   » by #{author} for #{assignee}"
  end
end

