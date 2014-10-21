# encoding: utf-8
require "socket"

module Irc

  unloadable

  def self.url(param)
    param[:host] = Setting.host_name
    param[:protocol] = Setting.protocol
    Rails.application.routes.url_helpers.url_for(param)
  end

  @@mutex = Mutex.new
  @@socket = nil
  @@listen = {}

  def self.register(klass, &block)
    @@listen[klass] = block
  end

  def self.say(message)
    @@socket.puts "NOTICE #{Setting.plugin_redmine_irc_notice['chan'].strip} :#{message}"
  end

  def self.notice(object)
    Thread.new do
      @@mutex.synchronize do
        begin
          if @@listen.key? object.class.name
            @@socket = TCPSocket.new(Setting.plugin_redmine_irc_notice['host'], Setting.plugin_redmine_irc_notice['port'].to_i)

            nick = object.class.name.split(':').last.downcase

            @@socket.puts "NICK #{nick}"
            @@socket.puts "USER #{nick} #{nick} #{nick} #{nick}"

            # Wait register
            begin
              line = @@socket.gets
            end while line !~ /001 #{nick}/

            # CTCP Time (not sure about that)
            @@socket.puts "NOTICE #{nick} #{Time.now}"

            @@listen[object.class.name].call(object)
          end
        rescue => e
          Rails.logger.error "Irc notification error: #{e.message}"
        ensure
          if not @@socket.nil? and @@socket
            @@socket.puts "QUIT"
            @@socket.flush
            @@socket.gets until @@socket.eof?
            @@socket.close
            @@socket = nil
          end
        end
      end
    end
  end

end