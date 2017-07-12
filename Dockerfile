FROM debian:stable

# add EPICS repo and repo-key
ADD http://epics.nsls2.bnl.gov/debian/repo-key.pub repo-key.pub
RUN apt-key add repo-key.pub
ADD epics.list /etc/apt/sources.list.d/

# Update the repo info
RUN apt-get update

# install and configure supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# change installation dialogs policy to noninteractive
# otherwise debconf raises errors: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

# change policy for starting services while installing
# otherwise policy-rc.d denies execution of start
# http://askubuntu.com/questions/365911/why-the-services-do-not-start-at-installation
# finally the approach is to not start services when building image
# the database will be fead from file, instead of creating tables
# RUN echo "exit 0" > /usr/sbin/policy-rc.d

# install mysql server
RUN apt-get install -y mysql-server

#install tango-db
RUN apt-get install -y tango-db

#install tango-test DS
RUN apt-get install -y tango-test

# install sardana dependencies
RUN apt-get install -y python ipython python-h5py python-lxml python-numpy\ 
                       python-nxs python-ply python-pytango python-qt4\ 
                       python-qwt5-qt4 python-guiqwt pymca

# install pip
RUN apt-get install -y python-pip

# install spyder V3 from pypi
RUN pip install spyder==3

# instal virtual monitor
RUN apt-get install -y xvfb

# configure virtual monitor env variable
ENV DISPLAY=:1.0

# configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/

# TODO: use just basic database, not the one with sardemo
# copy & untar mysql tango database (with sardemo) and change owner to mysql user
ADD tangodbsardemo.tar /var/lib/mysql/
RUN chown -R mysql /var/lib/mysql/tango

# define tango host env var
ENV TANGO_HOST=taurus-test:10000

# install epics
RUN apt-get install -y epics-dev

# install pyepics
RUN pip install pyepics

# copy test epics IOC database
ADD testioc.db /

# add latest taurus library 
RUN apt-get install python-pip -y
RUN pip install git+https://github.com/taurus-org/taurus.git@develop

# add USER ENV (necessary for spyderlib in taurus.qt.qtgui.editor)
ENV USER=root

# start supervisor as deamon
CMD ["/usr/bin/supervisord"]
