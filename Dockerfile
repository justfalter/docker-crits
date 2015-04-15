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
      zip && \ 
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN eatmydata easy_install --script-dir=/usr/bin -U pip

RUN eatmydata /usr/bin/pip install \
      anyjson==0.3.3 \
      cybox==2.1.0.5 \
      python-dateutil==2.2 \
      defusedxml==0.4.1 \
      django==1.6.5 \
      django-tastypie==0.11.0 \
      django-tastypie-mongoengine==0.4.5 \
      importlib==1.0.3 \
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
      uwsgi==2.0.10

ENV HOME /root
RUN useradd -m crits

RUN curl -o /tmp/crits.tgz https://codeload.github.com/crits/crits/tar.gz/v3.1.0 && \
    mkdir -p /data/crits && \
    tar xzf /tmp/crits.tgz -C /data/crits --strip-components 1 && \
    rm /tmp/crits.tgz && \
    chown -R crits:crits /data/crits

ADD docker /docker

EXPOSE 8001

VOLUME [ "/data/crits/logs" ]
VOLUME [ "/var/log" ]

WORKDIR /data/crits

CMD [ "start" ]

ENTRYPOINT [ "/bin/bash", "/docker/startup.sh" ]
