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

rss = RSS::Parser.parse(RSS_URL, false)
firstIssue = rss.items.first
guid = firstIssue.guid.content
lastKnownGuid = getLastKnownGuid
return if lastKnownGuid == guid

setLastKnownGuid(guid)

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
    result = Net::HTTP.post_form(INSTAPAPER_API_ADD_URI, params)
    puts result.kind_of?(Net::HTTPSuccess) ? "✅" : "❌"
    sleep 0.5
end
puts "🎉🎉🎉"
