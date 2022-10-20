# gdate

#### gdate gives bla bla bla
The script originally was part of a series of [manual lists of commands](qnd_kubed_commands.md) made to copy into the shell. It was designed to be quick, but polluted the shell history with excessive commenting.

bla bla bla:
  1. create a zonal cluster (and tell you the duration of time it took).
  2. deploy 3 Hello World containers.
  3. check the containers with the curl command
  4. offers to create a script to be used later to delete the container and the cluster, saving resources.

bla bla bla:
  - install a custom yaml script (which cancels the Hello World deployment)
  - install a second container called Keycloak
  - change cluster zone, or make a regional cluster
  - let you choose machine types
  - for more: `./qnd_kubed -h`

## Installation
Make sure you are logged in (gcloud auth login), and you have set your project (gcloud config set project <project>)

##### Download & make executable:
```
curl https://github.com/nocyber/gdate/blob/main/gdate.sh > gdate; chmod +x ./gdate
./gdate
```

## Usage
```
./andbdused                     # execut
./qnd_kubed -a "teacup" -K      # name the
```

---

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[GNE GPLv2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
