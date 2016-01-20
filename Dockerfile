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

# # install SLURM + dependencies
RUN apt-get install -y --no-install-recommends libmunge-dev libmunge2 munge

# RUN apt-get install -y --no-install-recommends lua-devel

RUN apt-get install -y --no-install-recommends slurm-wlm

# RUN apt-get install -y --no-install-recommends -fsL http://www.schedmd.com/download/total/slurm-15.08.3.tar.bz2 | tar xfj - -C /opt/ && \
#     cd /opt/slurm-15.08.3/ && \
#     ./configure && make && make install