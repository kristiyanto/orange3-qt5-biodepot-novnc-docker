FROM ubuntu:latest
MAINTAINER Daniel Kristiyanto

ENV DEBIAN_FRONTEND noninteractive
EXPOSE 6080
WORKDIR /root
ADD startup.sh startup.sh

RUN apt-get update -y
RUN apt-get install -y git x11vnc wget unzip xvfb openbox geany menu \
    build-essential python3 python3-dev python3-pip virtualenv libssl-dev \
    net-tools rox-filer python3-pyqt5 libqt5webkit5-dev python3-pyqt5.qtsvg \
    python3-pyqt5.qtwebkit
RUN git clone https://github.com/kanaka/noVNC.git && \
    cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify
RUN git clone https://github.com/biolab/orange3.git 
RUN pip3 install --upgrade pip
RUN pip3 install -r orange3/requirements-core.txt
RUN pip3 install -r orange3/requirements-gui.txt
RUN pip3 install docker-py numpy
WORKDIR /root/orange3
RUN pip3 install -e .

ADD biodepot /root/biodepot
RUN pip3 install -e /root/biodepot

RUN apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*
RUN chmod 0755 /root/startup.sh

ADD menu.xml  /root/.config/openbox/menu.xml 
ADD media/bg.png /root/.config/openbox/bg.png
RUN echo "hsetroot /root/.config/openbox/bg.png & orange-canvas" >> \
    /root/.config/openbox/autostart
ADD rc.xml /root/.config/openbox/rc.xml

WORKDIR /root
CMD /root/startup.sh

