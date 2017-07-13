# taurus-test

[Docker](http://www.docker.com) image configuration for testing [Taurus](http://www.taurus-scada.org).

It is based on a [Debian:8](http://www.debian.org)  and it provides the following infrastructure for installing and testing Taurus:

- xvfb, for headless GUI testing
- taurus dependencies and recommended packages (PyTango, PyQt, Qwt, guiqwt, spyder, ...)
- A Taurus librarys 
- A basic Epics system and a running SoftIoc for testing taurus-epics
 
The primary use of this Docker image is to use it in our [Continuous Integration workflow](https://travis-ci.org/taurus-org/taurus).

But you may also run it on your own machine:

~~~~
docker run -d --name=taurus-test -h taurus-test cpascual/taurus-test
~~~~

... or, if you want to launch GUI apps from the container:

~~~~
xhost +local:
docker run -d --name=taurus-test-2 -h taurus-test-2 -e DISPLAY=localhost:0  patfra7/taurus-test-2
~~~~

where "localhost" is ip of your PC

Then you can log into the container with:

~~~~
docker exec -it taurus-test-2 bash
~~~~

Note: **this image does not contain a Tango DB and TangoTest DS**, because it is configured to run with Databases in different containers.

Thanks to [reszelaz](https://github.com/reszelaz) for providing the first version of this docker image
and to [cpascual](https://github.com/cpascual) for developing it.
