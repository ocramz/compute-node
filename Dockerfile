# # compute-node : a generic compute node image using Slurm and Munge

FROM debian:7.7

RUN apt-get update

# # TLS-related
RUN apt-get install -y --no-install-recommends ca-certificates debian-keyring debian-archive-keyring
RUN apt-key update
RUN apt-get update

# # Install tools.
RUN apt-get install -y --no-install-recommends make gcc bzip2 gfortran wget curl python pkg-config


# # Set up environment variables
ENV LOCAL_DIR $HOME/.local
ENV BIN_DIR $HOME/.local/bin
ENV SRC_DIR $HOME/src

# # Create directories
RUN mkdir -p $LOCAL_DIR
RUN mkdir -p $BIN_DIR
RUN mkdir -p $SRC_DIR

# # check env
RUN printenv | grep DIR
RUN ls -lsA $HOME




# # BLCR (checkpoint/restart for MPI libraries)

ENV BLCR_VER 0.8.5

RUN wget http://crd.lbl.gov/assets/Uploads/FTG/Projects/CheckpointRestart/downloads/blcr-$BLCR_VER.tar.gz && tar zxf blcr-$BLCR_VER.tar.gz && cd blcr-$BLCR_VER && mkdir builddir && cd builddir && ../configure && make && make install && make insmod check

# # ====> NB!!! : BLCR kernel modules should be loaded with `insmod` for BLCR to work, see https://upc-bugs.lbl.gov/blcr/doc/html/BLCR_Admin_Guide.html





# # install SLURM and MUNGE
RUN apt-get install -y --no-install-recommends libmunge-dev libmunge2 munge

RUN apt-get install -y --no-install-recommends slurm-llnl



# # clean local package archive
RUN apt-get clean



# # test MUNGE

# RUN /usr/sbin/munged

# RUN munge -n | unmunge

# RUN remunge


