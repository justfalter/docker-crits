## Installation

1. MongoDB
2. SSL Certificate
3. Configuring crits

#### 1. MongoDB

###### Running MongoDB in a docker container

1. Create a data container for the mongodb data.

```
docker run --name crits_mongodb_data mongo:2.6 /bin/true
```

2. Start a mongodb container that leverages the data container:

```
docker run --restart="always" -d --name crits_mongodb --volumes-from=crits_mongodb_data  mongo:2.6
```

#### 2. Create CRITs containers

```
docker run  --name crits1_data  --entrypoint=/bin/true justfalter/crits
docker run --restart="always" -d --name crits1 --volume /path/to/your/config:/config --link=crits_mongodb:mongodb --volumes-from=crits1_data justfalter/crits
```

Initialize mongodb for the first time:
```
docker exec -ti crits1 python manage.py create_default_collections
```


#### 2. SSL Certificate

## Configuration



## User management

*Adding a user:*
```
docker exec -ti crits1  python manage.py users --adduser --administrator --username someguy -e foo@bar.com
```

*Resetting a user's password:*
```
docker exec -ti crits1  python manage.py users --reset -u mike
```

-----

Dropping the mongodb data:
```
docker exec -ti crits_mongodb mongo crits --verbose --eval "db.dropDatabase()"
```

