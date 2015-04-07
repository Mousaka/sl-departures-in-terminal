#!/usr/bin/env ruby
require 'json'
require 'curb'

platsuppslag_api = "INSERT YOUR API KEY HERE AS STRING"
realtidsinformation3_api = "INSERT YOUR API KEY AS STRING"

if ARGV.length>0
	search = ARGV.at(0)
end
if ARGV.length==2
	time_limit = ARGV.at(1)
else
	time_limit = "10"
end
	raw = Curl::Easy.perform("http://api.sl.se/api2/typeahead.json?key=#{platsuppslag_api}&searchstring=#{search}&stationsonly=true&maxresults=1")
	data = JSON.parse(raw.body_str)
	status_code = data["StatusCode"]
	station_name = data["ResponseData"][0]["Name"]
	site_id = data["ResponseData"][0]["SiteId"]
	raw_dep = Curl::Easy.perform("http://api.sl.se/api2/realtimedepartures.json?key=#{realtidsinformation3_api}&siteid=#{site_id}&timewindow=#{time_limit}")
	data_dep = JSON.parse(raw_dep.body_str)
	response_data = data_dep["ResponseData"]
	metros = response_data["Metros"]
	buses = response_data["Buses"]
	trains = response_data["Trains"]
	trams = response_data["Trams"]
	ships = response_data["Ships"]
	puts "Avgångar från #{station_name}:\n"

	if !metros.empty?
		puts "Tunnelbanor"
	end
	metros.each do|metro|
		puts "\t#{metro['DisplayTime']}\t#{metro['GroupOfLine']} mot #{metro['SafeDestinationName']}"
	end
	if !buses.empty?
		puts "Bussar"
	end
	buses.each do|bus|
		puts "\t#{bus['DisplayTime']}\tBuss #{bus['LineNumber']} mot #{bus['Destination']}"
	end
	if !trains.empty?
		puts "Pendeltåg"
	end
	trains.each do|train|
		puts"\t#{train['DisplayTime']}\tPendel linje #{train['LineNumber']} mot #{train['Destination']}"
	end
	if !trams.empty?
		puts "Lokaltåg"
	end
	trams.each do|tram|
		puts"\t#{tram['DisplayTime']}\t#{tram['GroupOfLine']} mot #{tram['Destination']}"
	end
