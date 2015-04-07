# sl-departures-in-terminal
This is a small Ruby script that allows you to list all departures of a station in Stockholm, Sweden.
Installation
-------------
First you must retrieve your own API-keys by signing up at trafiklab.se and then apply for the keys.
You need these two:
https://www.trafiklab.se/api/sl-realtidsinformation-3/sl-realtidsinformation-3
https://www.trafiklab.se/api/sl-platsuppslag/sl-platsuppslag

Once you have your API-keys, insert them into the code on line 5 and 6 as strings.

You need to be able to run Ruby scripts on your computer and you need to have the two ruby gems json and curb installed.
If you already have ruby working in your terminal you can install them by typing following in your terminal:

gem install json && gem install cub

How to use it
-------------
Use it by runnng the script in the terminal:

ruby sl-get-departures.rb STATION (TIME_INTERVAL_IN_MINUTES)

where STATION is replaced by a station name and the optional time interval can be a number 1 to 60.

Exampel:

ruby sl-get-departures.rb slussen 5

Will show all departures from Slussen that is within 5 minutes
