FROM ubuntu:18.04

ENV HOMEDIR /home/appuser
ENV INSTALLDIR /usr/local
RUN useradd --create-home appuser
WORKDIR ${INSTALLDIR}

RUN apt-get update

# build
RUN buildDeps='wget build-essential' \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& wget http://download.igb.uci.edu/SCRATCH-1D_1.2.tar.gz \ 
	&& tar xzf SCRATCH-1D_1.2.tar.gz && rm SCRATCH-1D_1.2.tar.gz \
	&& cd SCRATCH-1D_1.2 \
	&& perl install.pl \
	&& apt-get purge -y --auto-remove $buildDeps

ENV PATH $INSTALLDIR/SCRATCH-1D_1.2/bin:$PATH

RUN chmod a+x $INSTALLDIR/SCRATCH-1D_1.2/bin/run_SCRATCH-1D_predictors.sh

# fix some of the dependency issues
RUN apt-get install -y wget build-essential \
	&& wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.26/blast-2.2.26-x64-linux.tar.gz \
	&& tar xzf blast-2.2.26-x64-linux.tar.gz \
	&& rm blast-2.2.26-x64-linux.tar.gz \
	&& rm -r /usr/local/SCRATCH-1D_1.2/pkg/blast-2.2.26 \
	&& mv blast-2.2.26 /usr/local/SCRATCH-1D_1.2/pkg/ 

# Currently runs as root, this should be changed in future after figuring out correct file/folder permissions
#USER appuser
WORKDIR ${HOMEDIR}


#ENTRYPOINT ["IsUnstruct"]

