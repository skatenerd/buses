Overview
=====================
This project intends to investigate the bus-bunching that happens on the CTA.

Check out the [Artifacts](https://github.com/skatenerd/buses/tree/master/artifacts) directory to see the "output" of this project.  The diagrams show the relative progress of the buses.

The components of the project are:
* A task to perform scraping
* Analysis code
* Underlying Models (scraping saves to these, analysis consumes them)

There used to be an EC2 instance running the `Scrape` task, saving its data to an RDS instance.  I turned these all off because it got a little bit expensive.

In the days when the RDS instance was up, you could perform the analysis tasks locally (without SSHing to EC2), simply by giving your `config.yml` the RDS instance's read-only credentials.

Setup
=====================

In order to aggregate CTA data yourself, set up a cron job which runs the `Scrape` task every minute.  

You will have to tell the program which SQL database to write to.  In order to do this, you will have to copy `config.example.yml` to your own `config.yml`.  The example config file contains database credentials to a no-longer-existing RDS instance.  You should give it the credentials to your own SQL database.

You will also have to tell the program which "stop numbers" to be interested in.  The "stop number" is a CTA concept, and you can look stop numbers up using the CTA bus tracker. You will have to list the relevant "stop numbers" in your `config.yml`

Once you are scraping data, you can run the analysis tasks to output pretty pictures.  For instance, you could run `ruby graph_scatter.rb 1327` to get data about stop number `1327`
