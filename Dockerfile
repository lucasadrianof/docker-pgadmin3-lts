FROM ubuntu:16.04
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y software-properties-common curl && add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y python3.7
RUN apt-get install -y git

RUN mkdir -p /home/magamobi
WORKDIR /home/magamobi

RUN git clone https://github.com/allentc/pgadmin3-lts.git
RUN apt-get install -y libxml2 libxslt1-dev lbzip2 build-essential

RUN curl -L "https://github.com/wxWidgets/wxWidgets/releases/download/v2.8.12/wxGTK-2.8.12.tar.gz" --output wxGTK.tar.gz && tar -xvf wxGTK.tar.gz

RUN apt-get install -y libgtk2.0-dev
RUN cd wxGTK-2.8.12 && ./configure --with-gtk --enable-gtk2 --enable-unicode && make && make install

RUN cd /home/magamobi/wxGTK-2.8.12/contrib && make && make install

RUN apt-get install -y automake
RUN bash /home/magamobi/pgadmin3-lts/xtra/wx-build/build-wxgtk /home/magamobi/wxGTK-2.8.12

RUN apt-get install -y postgresql postgresql-contrib
RUN apt-get install -y libpq-dev
RUN service postgresql start

RUN apt-get install  postgresql-server-dev-9.5
RUN cd /home/magamobi/pgadmin3-lts && bash bootstrap && ./configure && make all && make install

RUN cp /home/magamobi/pgadmin3-lts/pgadmin/pgadmin3 /usr/bin

# remove building dependencies
RUN rm -rf /home/magamobi/pgadmin3-lts
RUN rm -rf /home/magamobi/wxGTK-2.8.12

CMD pgadmin3