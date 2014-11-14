Redmine::Plugin.register :redmine_irc_notice do
  name 'Redmine Irc Notice plugin'
  author 'Florent Solt'
  description 'Send irc notice when new issues & changesets'
  version '0.0.1'
  url 'https://github.com/florentsolt/redmine_irc_notice'

  settings :default => {
    'enabled' => true,
    'host' => 'localhost',
    'port' => 6667,
    'chan' => '#redmine',
    }, :partial => 'settings/irc'

end

require_dependency "irc"
require_dependency "register"
require_dependency "patch"