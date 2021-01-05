FROM ubi8

MAINTAINER Klaus Wagner <nenioscio@gmail.com>


# # Update image
# RUN yum -y update && \
#     yum -y clean all

# Install Requirements
RUN dnf --disableplugin=subscription-manager install curl hostname which libffi-devel zlib-devel bzip2-devel openssl-devel zlib mariadb-connector-c-devel sqlite-devel gcc gcc-c++ git make xz unzip cmake automake tar -y && \
    dnf -y clean all

ENV PYTHON_VERSION=3.9.1
RUN cd /usr/src && \
    curl -LO https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz && \
    tar xf Python-${PYTHON_VERSION}.tar.xz && \
    cd Python-${PYTHON_VERSION} && \
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

ENV UNRAR_VERSION=6.0.2
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

ENV SABNZBD_VERSION=3.1.1
RUN cd /app && \
    curl -LO https://github.com/sabnzbd/sabnzbd/archive/${SABNZBD_VERSION}.zip  && \
    unzip ${SABNZBD_VERSION}.zip && \
    mv sabnzbd-${SABNZBD_VERSION} sabnzbd && \
    cd sabnzbd && \
    source /app/venv/bin/activate && \
    pip install -r requirements.txt

CMD ["/app/venv/bin/python", "/app/sabnzbd/SABnzbd.py", "--config", "/config", "--disable-file-log"]
