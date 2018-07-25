#!/usr/bin/env ruby

require_relative 'secrets'
require_relative 'targets'
require 'rss'
require 'uri'

LASTKNOWNGUID_FILENAME = "#{__dir__}/.lastKnownGuid"

RSS_URL = "https://iosdevweekly.com/issues.rss"
LINKS_REGEX = /<h4><a href="(.*)">(.*)<\/a><\/h4>/

def getLastKnownGuid
    begin
        return File.read(LASTKNOWNGUID_FILENAME)
    rescue
        return nil
    end
end

def setLastKnownGuid(value)
    File.write(LASTKNOWNGUID_FILENAME, value)
end

case Config::TARGET
when "POCKET"
    target = PocketTarget.new
when "INSTAPAPER"
    target = InstapaperTarget.new
end

rss = RSS::Parser.parse(RSS_URL, false)
firstIssue = rss.items.first
guid = firstIssue.guid.content
lastKnownGuid = getLastKnownGuid
exit(true) if lastKnownGuid == guid

description = firstIssue.description
links = description.scan(LINKS_REGEX)

puts "👀 #{links.count} new articles found 👀"

links.each do |element|
    title = element[1]
    url = element[0]
    print "👉 #{title} "
    target.post(title, url)
    sleep 0.5
end

setLastKnownGuid(guid)

puts "🎉🎉🎉"
