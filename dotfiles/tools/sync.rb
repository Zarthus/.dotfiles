#!/usr/bin/env ruby
#
# Synchronize files from a syncmap between your computer
# and this repository.

require 'fileutils'

TOOLS_DIR = File.dirname(__FILE__)
SYNCMAP = TOOLS_DIR + "/.syncmap"
directive = :none

HOME_DIR = ENV.fetch('HOME', '/home/' + ENV.fetch('USER', 'E_INVALID_USER'))
PROJ_DIR = TOOLS_DIR + '/..'

raise "Home dir #{HOME_DIR} does not exist" unless Dir.exist? HOME_DIR
raise "Project dir #{PROJECT_DIR} does not exist" unless Dir.exist? PROJ_DIR

class Dir
    def self.back(path, levels = 1)
        path.split(File::SEPARATOR)[0..-(levels + 1)].join(File::SEPARATOR)
    end
end

class Sync
    def initialize(syncmap, &logger)
        raise "Syncmap #{syncmap} does not exists" unless File.exist? syncmap

        @syncmap = syncmap
        @syncfiles = []
        @logger = logger
    end

    def usage
        "Usage: app.rb <directive> :: e.g. app.rb machine"
    end

    def sync(to_path, from_path)
        load_syncmap

        log "[*] Start copy from #{from_path} to #{to_path}"
        @syncfiles.each do |path|
            log " [+] Copy #{path}"

            full_to_path = "#{to_path}/#{path}"
            full_from_path = "#{from_path}/#{path}"

            if !File.exist?(full_to_path) && !Dir.exist?(full_to_path)
                log " [!] warning: Path to_path #{full_to_path} does not exist, will be created"

                FileUtils.mkdir_p(Dir.back(full_to_path, 1))
            end

            if !File.exist?(full_from_path) && !Dir.exist?(full_from_path)
                log " [!] error: Path from_path #{full_from_path} does not exist"
                next
            end

            begin
                FileUtils.cp_r(full_from_path, full_to_path)
            rescue => e
               log " [!] error: failed to copy #{full_from_path} to #{full_to_path}"
               log " [!] cause: #{e.to_s}"
            end
        end

        log "[*] Complete!"
    end

    def load_syncmap
        return unless @syncfiles.empty?

        log "[*] Start loading from syncmap #{@syncmap}"

        File.readlines(@syncmap).each do |path|
            next if path.strip.empty?
            next if path.strip.start_with?('#')

            @syncfiles << path.strip

            log " [+] Loaded syncpath #{path.strip}"
        end

        if @syncfiles.empty?
            log " [!] syncmap #{@syncmap} is empty!" if @syncfiles.empty?
            raise "Syncmap is empty"
        end
    end

    def log(text)
        if @logger
            @logger.call(text)
        end
    end
end

sync = Sync.new(SYNCMAP, &method(:puts))

directive = ARGV.first

if directive.nil?
    puts sync.usage

    raise 'Directive cannot be nil.'
end

directive = directive.to_sym

if directive == :machine
    sync.sync(HOME_DIR, PROJ_DIR)
elsif directive == :repo || directive == :repository
    sync.sync(PROJ_DIR, HOME_DIR)
else
    puts sync.usage

    raise "Invalid directive #{directive}; must be machine, repo, or repository"
end
