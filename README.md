There is an EC2 instance polling the cta bus tracker predictions endpoint every minute, asking for predictions about Sacramento and Fullerton eastbound.

It writes the results of each query to an RDS instance.

In order to write to your own database, you'll have to update the config.yml.  Right now it connects with read-only access to the existing RDS database.

If you want to access the data from another project, View the data this way:
`psql -h buses.c4woir8uvpdl.us-west-2.rds.amazonaws.com -U readonly buses`
with password `password`
