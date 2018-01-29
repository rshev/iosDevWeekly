#!/usr/bin/env ruby

require_relative 'secrets'
require 'rss'
require 'uri'
require 'net/http'

LASTKNOWNGUID_FILENAME = '.lastKnownGuid'
INSTAPAPER_API_ADD_URI = URI('https://www.instapaper.com/api/add')

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

def pushToInstapaper(params)
    begin
        Net::HTTP.post_form(INSTAPAPER_API_ADD_URI, params)
    rescue
        puts "❌"
        return
    end
    puts "✅"
end

rss = RSS::Parser.parse(RSS_URL, false)
firstIssue = rss.items.first
guid = firstIssue.guid.content
lastKnownGuid = getLastKnownGuid
exit(true) if lastKnownGuid == guid

description = firstIssue.description
links = description.scan(LINKS_REGEX)

links.each do |element|
    title = element[1]
    params = {
        "username" => Config::INSTAPAPER_USERNAME,
        "password" => Config::INSTAPAPER_PASSWORD,
        "url" => element[0],
        "title" => title
    }
    print "👉 #{title} "
    pushToInstapaper(params)
    sleep 0.5
end

setLastKnownGuid(guid)

puts "🎉🎉🎉"
