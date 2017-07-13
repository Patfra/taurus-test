FROM debian:8

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

# install sardana dependencies python-nxs
RUN apt-get install -y python ipython python-h5py python-lxml python-numpy\ 
                       python-nxs python-ply python-pytango python-qt4\ 
                       python-qwt5-qt4 python-guiqwt pymca

# install pip
RUN apt-get install wget -y
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
# install spyder V3 from pypi
RUN pip install spyder==3

# instal virtual monitor
RUN apt-get install -y xvfb

# configure virtual monitor env variable
ENV DISPLAY=:1.0

# configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/

# define tango host env var
ENV TANGO_HOST=taurus-test:10000

# install epics
RUN apt-get install -y epics-dev

# install pyepics
RUN pip install pyepics

# copy test epics IOC database
ADD testioc.db /

# add latest taurus  
RUN apt-get install python-pip -y
RUN pip install -U taurus

# add latest taurus  
RUN apt-get install x11-xserver-utils -y

# add USER ENV (necessary for spyderlib in taurus.qt.qtgui.editor)
ENV USER=root

# start supervisor as deamon
CMD ["/usr/bin/supervisord"]
