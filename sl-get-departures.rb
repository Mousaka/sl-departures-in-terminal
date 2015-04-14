#!/usr/bin/env ruby
require 'json'
require 'curb'
require 'optparse'

platsuppslag_api = "INSERT YOUR API KEY HERE AS STRING"
realtidsinformation3_api = "INSERT YOUR API KEY AS STRING"

options = {}

opt_parser = OptionParser.new do |opt|
	opt.banner = "Usage: sl-get-departures.rb location [time_window] [FLAGS]"
	opt.separator  ""
	opt.separator  "Location"
	opt.separator  "	start: start server"
	opt.separator  ""
	opt.separator  "Flags"
	opt.separator  "	-s, --select-station"
	opt.separator  ""

	opt.on("-s","--select-station","activates station selection mode") do
		options[:selectionmode] = true
	end

	opt.on("-h","--help","help") do
		puts opt_parser
		abort
	end
end

opt_parser.parse!

if ARGV.length>2 or ARGV.length<1
	puts opt_parser
	abort
elsif ARGV.length==2
	time_limit = ARGV.at(1)
else
	time_limit = "20"
end

def get_sites_from_string(searchstring, selectionmode, platsuppslag_api)
	maxresults = 5

	raw = Curl::Easy.perform("http://api.sl.se/api2/typeahead.json?key=#{platsuppslag_api}&searchstring=#{searchstring}&stationsonly=true&maxresults=#{maxresults}")
	data = JSON.parse(raw.body_str)
	status_code = data["StatusCode"]
	stations = Array.new
	response_data = data["ResponseData"]
	response_data.each do|station|
		stations << [station["Name"], station["SiteId"]]
	end
	if selectionmode
		select_station stations
	else
		site_id = [data["ResponseData"][1], data["ResponseData"][0]["SiteId"]]
	end	
end

def select_station(stations)
	puts "Ange nummer för önskad station:\n"
	counter = 0
	stations.each do|station|
		puts "#{counter+=1} #{station[0]}"
	end
	selection = STDIN.gets.chomp.to_i
	if selection > 0 and selection < stations.size
		stations[selection-1]
	else
		puts "Felaktigt val! Försök igen!"
		select_station stations
	end
end

puts ""

search = ARGV.at(0)

site = get_sites_from_string search, options[:selectionmode], platsuppslag_api
site_id = site[1]
station_name = site[0]
raw_dep = Curl::Easy.perform("http://api.sl.se/api2/realtimedepartures.json?key=#{realtidsinformation3_api}&siteid=#{site_id}&timewindow=#{time_limit}")
data_dep = JSON.parse(raw_dep.body_str)
response_data = data_dep["ResponseData"]

def load_if_not_empty(response_data, type)
	if response_data[type].empty?
		[]
	else
		response_data[type]
	end
end

metros = load_if_not_empty response_data, "Metros"
buses = load_if_not_empty response_data, "Buses"
trains = load_if_not_empty response_data, "Trains"
trams = load_if_not_empty response_data, "Trams"
ships = load_if_not_empty response_data, "Ships"

puts "Avgångar från #{station_name}:\n"
nothing = true
if !metros.empty?
	puts "Tunnelbanor"
end
metros.each do|metro|
	puts "\t#{metro['DisplayTime']}\t#{metro['GroupOfLine']} mot #{metro['SafeDestinationName']}"
	nothing = false
end
if !buses.empty?
	puts "Bussar"
end
buses.each do|bus|
	puts "\t#{bus['DisplayTime']}\tBuss #{bus['LineNumber']} mot #{bus['Destination']}"
	nothing = false
end
if !trains.empty?
	puts "Pendeltåg"
end
trains.each do|train|
	puts"\t#{train['DisplayTime']}\tPendel linje #{train['LineNumber']} mot #{train['Destination']}"
	nothing = false
end
if !trams.empty?
	puts "Lokaltåg"
end
trams.each do|tram|
	puts"\t#{tram['DisplayTime']}\t#{tram['GroupOfLine']} mot #{tram['Destination']}"
	nothing = false
end

if nothing
	puts "Inga avgångar inom tidsramen #{time_limit} min"
end