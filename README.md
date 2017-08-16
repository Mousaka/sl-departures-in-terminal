# :light_rail: sl-departures-in-terminal
This is a small Ruby script that allows you to list all departures of a station in Stockholm, Sweden.
Installation
-------------
1. First you must retrieve your own API-keys by signing up at trafiklab.se and then apply for the keys. You need these two:
  * https://www.trafiklab.se/api/sl-realtidsinformation-3/sl-realtidsinformation-3
  * https://www.trafiklab.se/api/sl-platsuppslag/sl-platsuppslag
2. Once you have your API-keys use them to set these two required environment variables like such:

   ```bash
   export PLATSUPPSLAG_API=<INSERT_API_KEY_HERE>
   export REALTIDSINFORMATION4_API=<INSERT_API_KEY_HERE>
   ```
3. You need to be able to run Ruby scripts on your computer and you need to have the two ruby gems json and curb installed. If you already have ruby working in your terminal you can install them by typing following in your terminal:
   ```
   gem install json && gem install curb
   ```
   You need ruby-dev to use gem properly
   ```
   sudo apt-get install ruby-dev
   ```
   You might need to install libcurl4-openssl-dev in order to install curb gem:
   ```
   sudo apt-get install libcurl4-openssl-dev
   ```
   
How to use it
-------------
Use it by runnng the script in the terminal:
```
ruby sl-get-departures.rb STATION [TIME_INTERVAL_IN_MINUTES] [-s]
```
where STATION is replaced by a station name and the optional time interval can be a number 1 to 60 (default value is 20 min). The optional flag -s or --select-station enables you to chose a station with a similar name to the one you searched for.

#### Three examples of running the script
```
ruby sl-get-departures.rb universitetet 
```
Will show all departures from sl-plattsupplsag's best guess of what "Universitetet" is (it will guess that it is the metro station called Universitetet) that are within 20 min.


   ```
   ruby sl-get-departures.rb universitetet 30
   ```
   Will do the same as above but with increased time window.
   ```
   ruby sl-get-departures.rb universitetet 30 -s
   ```
   Will do the same as above but you now you get the options to chose from 5 stations that has a similar name to       universitetet. It lists the options for you. Looks something like this for Universitetet:
   ```
1 Universitetet (Tunnelbana och buss)  (Stockholm)
2 Universitetet norra (Stockholm)
3 Universitetet (Roslagsbanan)  (Stockholm)
4 Universitetet södra (Stockholm)
5 Universitetsvägen (Stockholm)
```


