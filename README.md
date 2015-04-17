# Docker service for CRITs
This Dockerfile provides an instance of [CRITs](https://crits.github.io/) behind [uWSGI](https://uwsgi-docs.readthedocs.org). You will not be able to run CRITs with this image alone. Rather, our hope was just to make getting CRITs up and running a bit easier for you. 

This image is intended to be put behind a reverse proxy, such as [nginx](http://nginx.org/) or [Apache HTTP Server](http://httpd.apache.org/). 

# Features

* CRITs web application is served via uWSGI.  
* Dependencies for most [CRITs services](https://github.com/crits/crits_services/) have already been installed, making them availbe for your usage. 

# Anti-Features

* Does not add any user accounts. 
* Does not install any SSL certificates. 
* Does not provide MongoDB. 

# CRITs services
## Available Services
Dependencies for the following services have been installed, so they are 
available for usage. Some of them require a bit more configuration, as CRITs
does not provide a way to configure services from the CLI. 

### carver\_service
### crits\_scripts
### chopshop\_service
Configuration settings you'll need to change:
* **basedir**: */data/chopshop*

### data\_miner_service
### entropycalc\_service
### machoinfo\_service
### metacap\_service
Configuration settings you'll need to change:
* **basedir**: */data/chopshop*

### meta\_checker
### office\_meta_service
### opendns\_service
### passivetotal\_service
### pdfinfo\_service
### peinfo\_service
### relationships\_service
### ssdeep\_service
### taxii\_service
### threatrecon\_service
### timeline\_service
### totalhash\_service
### upx\_service
### virustotal\_service
### yara\_service
### zip\_meta_service

## Services not Available (yet)
The following have not been enabled, yet, for one reason or another.
### OPSWAT\_service
### anb\_service
### clamd\_service
### cuckoo\_service
### pyew
### snugglefish\_service

# Getting up and running.

## Test environment
Just want to take CRITs for a spin? Try out our development environment.

**NOTE**: under no circumstances should this procedure be used as a short-cut to a production deployment. Rather, it was created simply as a means to make development of this Docker image easier. Following this procedure will result in an instance of CRITs with the following security issues:
* SSL is disabled.
* Session cookies do not have the 'secure' attribute.
* CRITs will have an empty SECRET\_KEY.

### Requirements

* [Docker 1.5.0](https://docs.docker.com/installation/)
* [docker-compose](https://docs.docker.com/compose/install/)
* [git](http://git-scm.com)

### Procedure for setting up test environment

#### Get the source code. 
```
git clone https://github.com/justfalter/docker-crits.git
```

#### Bring up the test environment.
In the root of the source tree, bring up the environment using docker-compose:
```
docker-compose up -d
```

#### Figure out the name of your CRITs container.
It's usually something like **dockercrits\_crits\_1**. You can find out by running the following:
```
docker-compose ps
```

#### Add an administrator account
You can find details on how to add a user [here](#adding-a-user).

#### Log into the CRITs interface 
You can log into your new CRITs instance at [http://localhost:8080](http://localhost:8080).

That's it!

## Production
A production environment should consist of the following:
1. A MongoDB server instance. 
2. An SSL-enabled HTTP service that acts as a reverse proxy for your CRITs application container. 
3. The CRITs application container.

The [CRITs wiki](https://github.com/crits/crits/wiki) already has information on setting up a [production-grade CRITs install](https://github.com/crits/crits/wiki/Production-grade-CRITs-install), so please read that over. 

### MongoDB
There many sources on the internet for installing MongoDB. Just know that the MongoDB server will be running *outside* of the CRITs application container. 

**Security consideration:** Make sure that your MongoDB server is **not** accessible outside of your network. 

#### Optional: Creating a MongoDB docker container
You may know this already, but Docker makes it pretty easy to set up a MongoDB container. I'm not suggesting that this is the best way to run MongoDB, but it certainly is *a* way.

Create a [data-volume-only container](http://docs.docker.com/userguide/dockervolumes/) for MongoDB: 
```
docker run --restart="always" -d --name crits_mongodb_data mongo:2.6 /bin/true
```

**Note:** The data-volume-only container will exit, immediately, which is to be expected. Despite this, fight the urge to delete it, as this is where your MongoDB data resides. It exists to make it easier to upgrade to a new version of MongoDB without having to worry about losing all of your data. It might be hard to wrap your head around at first, but if you spend any amount of time working with Docker containers, you'll appreciate the value of using a data-volume-only container. 

Now, we create the actual MongoDB container. Replace IP\_ADDRESS with the IP address of one of your network interfaces (such as eth0). This will be the same IP address that we configure CRITs to use when for communicating with MongoDB.
```
docker run --restart="always" -d --name crits_mongodb --volumes-from=crits_mongodb_data -p IP_ADDRESS:27017:27017  mongo:2.6
```

### The CRITs container

**Security consideration:** Make sure that your CRITs application container service is **not** accessible directly accessible outside of your network. It should only be accessible via the secured reverse proxy. 

**Security consideration:** Traffic between the reverse proxy and the CRITs container is not encrypted. Be mindful of the networks that your data is traversing!

#### Create the configuration files

1. Make a directory somewhere on your Docker host computer that will contain the CRITs configuration file(s).
```
mkdir /opt/crits-config
```

2. Copy *config/database_example.py* to your, but name it *database.py*.
```
cp config/database_example.py /opt/crits-config/database.py
```

3. Edit *database.py*, following the instructions within. Minimally, you'll be editing *MONGO\_HOST* and *SECRET\_KEY*. You can find some additional information about this here: [CRITs wiki instructions on editing database.py](https://github.com/crits/crits/wiki/Production-grade-CRITs-install). Save your changes to *database.py* before moving on. 


#### Starting the CRITs container

Now we start up the CRITs container. We'll be *mounting* the configuration directory we created, earlier, as */config* within the container. Replace IP\_ADDRESS with the IP address of one of your network interfaces (such as eth0). This will be the IP address that you will provide to your reverse proxy, later on. 

```
docker run --restart="always" -d --name crits --volume /opt/crits-config:/config -p IP_ADDRESS:8080:8080 justfalter/crits:latest
```

**Security consideration:** Make sure that the IP address that you bind the CRITs application container to is **not** publicly accessible!

If you ever need to make any changes to database.py, just edit the file within the your configuration directory (ex: /opt/crits-config/database.py), and restart the CRITs container.

#### Initializing the CRITs MongoDB collections
See [Creating the default collections for MongoDB](creating-the-default-collections-for-mongodb).

#### Add an administrator user
See [Adding a user](#adding-a-user).

### The Reverse Proxy

Now, you'll set up your reverse proxy. It's up to you as to what you use as a reverse proxy. You can find an example of using nginx in within **contrib/nginx**. 

Regardless of what you use as a reverse proxy, you should always keep the following things in mind:

* It communicates with your CRITs application using plain HTTP. Configure it to talk to the CRITs container's IP and port-number that you assigned, earlier.
* It only accepts HTTPS traffic on the public side. If your reverse proxy is not using SSL, then the sessionid cookies that CRITs creates **will not work**, as they have the *secure* flag on them.
* It **must** send set the following HTTP headers when passing requests to the CRITs container:
 * **Host** - this must be the original Host HTTP header that was requested of the reverse proxy. Failing to set this will result in the browser redirecting to weird places.
 * **X-Forwarded-Proto** - this should be *https*, matching your reverse proxy's protocol.
 * **X-Forwarded-For** - This relays to the CRITs all the proxies that the request has passed through, but more importantly the original IP address of the client making the request. This is important if the audit logs are to be accurate.

# Common tasks

## NOTE: Running commands within the CRITs container

Some of the initial configuration of CRITs occurrs via the command-line, usually
with the *manage.py* script. Since CRITs is running within a Docker container, you'll
have to do things slightly differently. 

The working directory of your CRITs container is */data/crits*. In this directory, you'll find the ever-so-useful *manage.py* script. Running this script is pretty simple:
```
docker exec -ti CRITS_CONTAINER_NAME python manage.py
```

Just replace CRITS\_CONTAINER\_NAME with the name of your CRITs container.

## Creating the default collections for MongoDB
This should only be run once, when you initially set up CRITs. 

```
docker exec -ti CRITS_CONTAINER_NAME python manage.py create_default_collections
```

## Adding a user

Addding an administrator user:
```
docker exec -ti CRITS_CONTAINER_NAME python manage.py users --adduser --administrator --username USERNAME -e EMAIL_ADDRESS
```
When this command succeeds, it'll spit out a temporary password for the account.

If you don't want to add an administrator, simply remove the *--administrator* from the command.

## Resetting a user's password
```
docker exec -ti CRITS_CONTAINER_NAME python manage.py users --reset --username USERNAME 
```

Dropping the mongodb data:
```
docker exec -ti crits_mongodb mongo crits --verbose --eval "db.dropDatabase()"
```

