FROM ubi8/ubi

MAINTAINER Klaus Wagner <nenioscio@gmail.com>


# Update image
RUN yum -y update && \
    yum -y upgrade && \
    yum -y clean all

# Install Requirements
RUN yum install curl hostname which libffi-devel zlib-devel bzip2-devel openssl-devel zlib gcc gcc-c++ git make xz unzip cmake automake -y && \
    yum -y clean all

ENV MARIADB_CONNECTOR_VERSION=3.1.9 
RUN cd /usr/src && \ 
    git clone https://github.com/mariadb-corporation/mariadb-connector-c
    cd mariadb-connector-c && \
    git checkout ${PAR2_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 24 install && \
    cd ../.. && \
    rm -rf mariadb-connector-c-${MARIADB_CONNECTOR_VERSION}-src mariadb-connector-c-${MARIADB_CONNECTOR_VERSION}-src.tar.gz


ENV SQLITE_VERSION=3330000
#COPY sqlite-autoconf-${SQLITE_VERSION}.tar.gz /usr/src
RUN cd /usr/src && \
    curl -LO https://www.sqlite.org/2020/sqlite-autoconf-${SQLITE_VERSION}.tar.gz  && \
    tar xf sqlite-autoconf-${SQLITE_VERSION}.tar.gz && \
    cd sqlite-autoconf-${SQLITE_VERSION} && \
    ./configure --prefix=/opt/sqlite3 && \
    make -j 24 install && \
    cd .. && \
    rm -rf sqlite-autoconf-${SQLITE_VERSION} sqlite-autoconf-${SQLITE_VERSION}.tar.gz

ENV PYTHON_VERSION=3.8.5
RUN cd /usr/src && \
    curl -LO https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz && \
    tar xf Python-${PYTHON_VERSION}.tar.xz && \
    cd Python-${PYTHON_VERSION} && \
    export LD_RUN_PATH=/opt/sqlite3/lib && \
    export LDFLAGS="-L/opt/sqlite3/lib" && \
    export CPPFLAGS="-I/opt/sqlite3/include"  && \
    ./configure --prefix=/opt/python3 --enable-optimizations && \
    make -j 24 install && \
    /opt/python3/bin/pip3 install virtualenv && \
    cd .. && \
    rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tar.xz

ENV PAR2_VERSION=v0.8.1
RUN cd /usr/src && \
    git clone https://github.com/Parchive/par2cmdline.git && \
    cd par2cmdline && \
    git checkout ${PAR2_VERSION} && \
    ./automake.sh && \
    ./configure && \
    make -j 24 install && \
    cd .. && \
    rm -rf par2cmdline

ENV UNRAR_VERSION=5.9.4
RUN cd /usr/src && \
    curl -LO https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz && \
    tar xf unrarsrc-${UNRAR_VERSION}.tar.gz && \
    cd unrar && \
    make -j 24 && \
    make -j 24 install && \
    cd .. && \
    rm -rf unrar unrarsrc-${UNRAR_VERSION}.tar.gz


RUN mkdir -p /app/venv && \
    /opt/python3/bin/virtualenv /app/venv && \
    source /app/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install uwsgi

ENV SABNZBD_VERSION=3.0.1
RUN cd /app && \
    curl -LO https://github.com/sabnzbd/sabnzbd/archive/${SABNZBD_VERSION}.zip  && \
    unzip ${SABNZBD_VERSION}.zip && \
    mv sabnzbd-${SABNZBD_VERSION} sabnzbd && \
    cd sabnzbd && \
    source /app/venv/bin/activate && \
    pip install -r requirements.txt

CMD ["/app/venv/bin/python", "/app/sabnzbd/SABnzbd.py", "--config", "/config", "--disable-file-log"]
