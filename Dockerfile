FROM python:3.5-onbuild

# todo: Revert this entire pull request when libcairo2 >= 1.14.2 is available from the debian
#       jessie repo.  This is a temporary fix for https://github.com/Kozea/WeasyPrint/issues/233

# reconfigure Debian to allow installs from both stretch (testing) repo and jessie (stable) repo
RUN echo 'APT::Default-Release "stable";' > /etc/apt/apt.conf
RUN mv /etc/apt/sources.list /etc/apt/sources.list.d/stable.list
RUN echo "deb http://ftp.debian.org/debian stretch main" > /etc/apt/sources.list.d/testing.list

# install all the dependencies except libcairo2 from jessie, then install libcairo2 from stretch
RUN apt-get -y update \
    && apt-get install -y \
        fonts-font-awesome \
        libffi-dev \
        libgdk-pixbuf2.0-0 \
        libpango1.0-0 \
        python-dev \
        python-lxml \
        shared-mime-info \
&& apt-get install -y libcairo2=1.14.8-1
&& apt-get -y clean

# Bit I have added 
RUN wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb
RUN dpkg -i ttf-mscorefonts-installer_3.6_all.deb

EXPOSE 5001

CMD gunicorn --bind 0.0.0.0:5001 wsgi:app
