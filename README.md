# thrusql

Docker image to access German emission data from thru.de.

Build:
```
docker build . -t thru
```

Run:
```
docker run -p 3306:3306 -p 80:80 thru
```

This will open a web server with phpMyAdmin on port 80 and a MySQL / MariaDB server on
port 3306 (Username/password: thru/thru).

Example usage:

We want to know who the biggest CO₂ polluter in Germany is:
```
echo "SELECT facility_id FROM releases WHERE pollutant_name='Carbon dioxide (CO2)' AND year='2021' ORDER BY annual_load DESC limit 1;"|mariadb --skip-ssl -u thru -h localhost -P 3306 -p thru
```

Result:
```
facility_id
78073
```

Who is 78073?
```
echo "SELECT name FROM facilities WHERE id=78073"|mariadb --skip-ssl -u thru -h localhost -P 3306 -p thru
```

Result:
```
name
RWE Power AG - Kraftwerk Neurath
```

## data

The German environmental agency (Umweltbundesamt) publishes emission data about
facilities in Germany on the web page [thru.de](https://thru.de/). The data is available
in SQLite format. The Dockerfile published here allows converting that data to MySQL and
accessing it via SQL commands directly or via phpMyAdmin.

## about

This Dockerfile was written by [Hanno Böck](https://hboeck.de/). You can find a similar
project for [European emission data here](https://github.com/decarbonizenews/ghgsql).

You may also want to check:

* [Errors and Inconsistencies in European Emission Data (Industry Decarbonization
  Newsletter, Dec 2025)](
  https://industrydecarbonization.com/news/errors-and-inconsistencies-in-european-emission-data.html)
* [ Greenhouse Gas Emission Data - Public, difficult to access, and not always correct
  (video recording of presentation at #39C3, Dec 2025)](
  https://media.ccc.de/v/39c3-greenhouse-gas-emission-data-public-difficult-to-access-and-not-always-correct)
