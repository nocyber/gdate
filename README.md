
![gdate_pic](https://user-images.githubusercontent.com/87066300/199491157-2b0fc275-0ff0-40a5-b611-ea4a986a0e6b.png)

# gdate

#### gdate provides a simple dashboard to get detailed time information.
  1) Provides Local, Standard, and Daylight time for the current city (set to Montreal by default) 
  2) Provides a World Clock of various cities, showing about half the World timezones.
  3) Displays syntax examples for quick Timezone calculations.


## Installation
This can be used in your local terminal.

#### Download & make executable:
```
curl https://raw.githubusercontent.com/nocyber/gdate/main/gdate.sh > ./gdate && chmod u+x ./gdate
```

#### Run:
```
./gdate
```

![gdate2_v0 96](https://user-images.githubusercontent.com/87066300/199619017-5da0165d-34cc-4749-93c7-000fc94bb2ad.png)


---

## Options:
```
./gdate -m                      # no commands, only clocks
./gdate -x                      # more commands, how to list cities, etc....
```

## Live clock
- Display only clocks[./gdate -m], in color [-c], and refresh every 60 seconds[-n 60].
- (Press [ctrl-c] to quit)
```
watch -c -n 60 "./gdate -m"
```




## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[GNE GPLv2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
