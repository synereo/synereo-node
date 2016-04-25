# Synereo Dockerfiles

Dockerfiles for easily setting up a Synereo node.

## Prerequisites

Install and be familiar with [Docker](https://docs.docker.com/userguide/). On OS X or Windows you'll probably want to use [Kitematic](https://docs.docker.com/kitematic/). On Linuxes with modern kernels, such as Arch Linux, you can just use plain [Docker](https://wiki.archlinux.org/index.php/Docker).

## Architecture

### Dependencies

Synereo nodes have two official Docker images as dependencies: [RabbitMQ](https://registry.hub.docker.com/_/rabbitmq/) and [MongoDB](https://registry.hub.docker.com/_/mongo/).

### Synereo Image

The Synereo image is built from [synereo/Dockerfile](synereo/Dockerfile). For full flexibility, instead of building on existing images we install all the dependencies ourselves, but we rely on much of the good code from these repos:

 - https://registry.hub.docker.com/_/java/
 - https://registry.hub.docker.com/u/williamyeh/scala/
 - https://registry.hub.docker.com/u/williamyeh/sbt/

## Usage

For most uses, you can just grab the image off of the Docker registry, located at [https://registry.hub.docker.com/u/synereo/synereo/](https://registry.hub.docker.com/u/synereo/synereo/). Using Docker you can just:

```bash
$ docker pull synereo/synereo
```

Alternatively, you can build the image yourself, but note that building can take up to 30-40 minutes (SBT be damned):

```bash
$ cd synereo
$ docker build -t synereo/synereo .
```

Once the image is created you can run stuff in it, e.g. to get a bash prompt and check the versions, run:

```bash
$ docker run -it synereo/synereo /bin/bash
root@1122aabb3344ccdd# java -version
root@1122aabb3344ccdd# scala -version
root@1122aabb3344ccdd# sbt -version
```

### Testing

Integration testing for the RabbitMQ connections can be done by following these steps on a single host:

```bash
$ docker run -d --hostname rabbit1 --name rabbit1 -e RABBIT_ERLANG_COOKIE='s3cr3t' -p 5672:5672 -p 15672:15672 rabbitmq
$ docker run -d --hostname rabbit2 --name rabbit2 -e RABBIT_ERLANG_COOKIE='s3cr3t' -p 5673:5672 -p 15673:15672 rabbitmq
```

When attempting to run this test on two separate hosts (either on the LAN or the WAN) you *must* expose the RabbitMQ port by using the `-p 5672:5672` option, in addition to any further firewall configurations on both hosts. Note that we use port 5673 on the second instance (if it's located on the same host).

In two separate terminals, launch one Synereo process each:

```bash
$ docker run --name synereo1 --link rabbit1:rabbit -it synereo/synereo /bin/bash  # terminal 1
$ docker run --name synereo2 --link rabbit2:rabbit -it synereo/synereo /bin/bash  # terminal 2
```

In each shell, take note of the RabbitMQ connection string, then launch the `sbt console`:

```bash
$ echo RABBIT_PORT
tcp://172.17.0.1:5672  # YMMV
$ cd /app/strategies-master
$ sbt console
```

In each console, run the following commands:

```scala
scala> import java.net.URI
scala> import com.biosimilarity.lift.lib._
scala> import com.biosimilarity.lift.lib.usage.AMQPTPSample._
scala> import _root_.com.rabbitmq.client.{Channel=>RabbitChan, _}
scala> val srcHost1 = new URI( "amqp://guest:guest@172.17.0.1:5672/synereo" )
scala> val trgtHost1 = new URI( "amqp://guest:guest@172.17.0.2:5672/synereo" )
```

Make sure to use the right source and target IPs, and to flip them on the other console. Then, in one console run:

```scala
scala> setupAndRunTest( true, srcHost1, trgtHost1, "synereo1", true, 10 )
```

While running this line in the other:

```scala
scala> setupAndRunTest( false, srcHost1, trgtHost1, "synereo1", true, 10 )
```

If all went well, you should see a successful test summary ending with `Test successful.`.

