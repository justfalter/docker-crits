FROM ubuntu:trusty
MAINTAINER Mike Ryan <falter@gmail.com>

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y eatmydata && \
  eatmydata apt-get install -y \
      build-essential \
      curl \
      libevent-dev \
      libfuzzy-dev \
      libldap2-dev \
      libpcap-dev \
      libpcre3-dev \
      libsasl2-dev \
      libxml2-dev \
      libxslt1-dev \
      m2crypto \
      numactl \
      p7zip-full \
      python-dev \
      python-lxml \
      python-m2crypto \
      python-matplotlib \
      python-numpy \
      python-pycurl \
      python-pydot \
      python-pyparsing \
      python-setuptools \
      python-yaml \
      ssdeep \
      unrar-free \
      upx \
      zip \ 
      yara \
      tshark \
      tcpdump \
      zlib1g-dev && \ 
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN eatmydata easy_install --script-dir=/usr/bin -U pip

RUN eatmydata /usr/bin/pip install \
      anyjson==0.3.3 \
      bitstring==3.1.3 \
      cybox==2.1.0.5 \
      python-dateutil==2.2 \
      defusedxml==0.4.1 \
      django==1.6.5 \
      django-tastypie==0.11.0 \
      django-tastypie-mongoengine==0.4.5 \
      importlib==1.0.3 \
      libtaxii==1.1.102 \
      mongoengine==0.8.7 \
      pillow==2.4.0 \
      pydeep==0.2 \
      python-ldap==2.4.15 \
      python-magic==0.4.6 \
      simplejson==3.5.2 \
      stix==1.1.1.0 \
      requests==1.1.0 \
      celery==3.0.12 \
      ushlex==0.99 \
      pymongo==2.7.2 \
      yara==1.7.7 \
      uwsgi==2.0.10 \
      dnslib==0.9.4

RUN eatmydata /usr/bin/pip install --allow-external pefile --allow-unverified pefile pefile
RUN eatmydata /usr/bin/pip install https://github.com/MITRECND/pynids/archive/0.6.2.zip
RUN eatmydata /usr/bin/pip install https://github.com/MITRECND/htpy/archive/RELEASE_0.21.zip

ENV HOME /root
RUN useradd -m crits

RUN curl -o /tmp/chopshop.tgz https://codeload.github.com/MITRECND/chopshop/tar.gz/RELEASE_4.2 && \
    mkdir -p /data/chopshop && \
    tar xzf /tmp/chopshop.tgz -C /data/chopshop --strip-components 1 && \
    rm /tmp/chopshop.tgz && \
    chown -R crits:crits /data/chopshop

RUN curl -o /tmp/crits.tgz https://codeload.github.com/crits/crits/tar.gz/v3.1.0 && \
    mkdir -p /data/crits && \
    tar xzf /tmp/crits.tgz -C /data/crits --strip-components 1 && \
    rm /tmp/crits.tgz && \
    chown -R crits:crits /data/crits

RUN curl -o /tmp/crits_services.tgz https://codeload.github.com/crits/crits_services/tar.gz/v3.1.0 && \
    mkdir -p /data/services-available && \
    tar xzf /tmp/crits_services.tgz -C /data/services-available --strip-components 1 && \
    rm /tmp/crits_services.tgz && \
    chown -R crits:crits /data/services-available

ADD docker /docker

RUN mkdir /config
RUN cp /data/crits/crits/config/database_example.py /config
RUN cp /data/crits/crits/config/overrides_example.py /config
VOLUME [ "/config" ]

# HTTP socket
EXPOSE 8080
# uWSGI socket
EXPOSE 8001

WORKDIR /data/crits

CMD [ "start" ]

ENTRYPOINT [ "/bin/bash", "/docker/startup.sh" ]
