Irc.register "Changeset" do |changeset|

  issue = changeset.issues.first

  first_line = "New changeset"

  if changeset.user.is_a? User
    first_line << " by #{changeset.user.login.titleize}"
  end

  if not issue.nil?
    first_line << " for issue \"#{issue.subject}\" in #{issue.project.name}"
  end

  Irc.say first_line

  if not changeset.comments.gsub(/([r#]\d+)|merge|trunk|qa|prod|in|to/i, '').strip.empty?
    changeset.comments.split("\n").each do |line|
      Irc.say "   » #{line.gsub('#', '')}"
    end
  end

  if not issue.nil?
    url = Irc.url(issue.event_url)
    Irc.say "   » #{url} (issue)"
  end

  url = Irc.url(changeset.event_url)
  Irc.say "   » #{url}"

end

Irc.register "Issue" do |issue|

  first_line = "New action "

  if issue.author
      first_line << " by #{issue.author.login.titleize}"
  end

  if issue.assigned_to
      first_line << " for #{issue.assigned_to.login.titleize}"
  end

  first_line << " in #{issue.project.name}"

  Irc.say first_line
  Irc.say "   » #{issue.subject}"

  url = Irc.url(issue.event_url)
  Irc.say "   » #{url}"

end
