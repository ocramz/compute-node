# # compute-node : a generic compute node image using Slurm and Munge

FROM debian:7.7

RUN apt-get update

# # TLS-related
RUN apt-get -qq install -y --no-install-recommends ca-certificates debian-keyring debian-archive-keyring
RUN apt-key update
RUN apt-get -qq update

# # Install tools
RUN apt-get -qq install -y --no-install-recommends make gcc bzip2 unzip gfortran wget curl python pkg-config perl

# # # ==== kernel stuff
# # RUN apt-get install linux-headers-$(uname -r)
# # RUN apt-get install -y --no-install-recommends kernel-devel kernel-headers

# # # recompile kernel with original configuration:
# # # 1. copy config
# RUN cp /boot/config-`uname -r` /usr/src/linux-`uname -r`/.config
# # # 2.
# RUN cp /lib/modules/`uname -r`/build/Makefile /usr/src/linux-`uname -r`
# RUN make


# # Set up environment variables
ENV LOCAL_DIR $HOME/.local
ENV BIN_DIR $HOME/.local/bin
ENV SRC_DIR $HOME/src

# # Create directories
RUN mkdir -p $LOCAL_DIR
RUN mkdir -p $BIN_DIR
RUN mkdir -p $SRC_DIR

# # augment PATH
ENV PATH $BIN_DIR:$PATH


# # check env
RUN printenv | grep DIR
RUN ls -lsA $HOME
# # where is the kernel ? 
RUN cat /proc/cmdline


# # # == BLCR dependencies
# RUN find ~ -name version.h
# RUN find ~ -name vmlinux



# ENV KERNEL_PATH /boot
# ENV KERNEL vmlinuz-3.19.0-30-generic
# # kernel : /boot/vmlinuz-3.19.0-30-generic






# # # ==== BLCR (checkpoint/restart for MPI libraries)

# ENV BLCR_VER 0.8.5

# # # from source 
# RUN wget http://crd.lbl.gov/assets/Uploads/FTG/Projects/CheckpointRestart/downloads/blcr-$BLCR_VER.tar.gz && tar zxf blcr-$BLCR_VER.tar.gz && cd blcr-$BLCR_VER && mkdir builddir && cd builddir && ../configure --with-linux=$KERNEL_PATH && make && make install && make insmod check

# # # => NB!!! : BLCR kernel modules should be loaded with `insmod` for BLCR to work, see https://upc-bugs.lbl.gov/blcr/doc/html/BLCR_Admin_Guide.html



# # # ==== Consul
ENV CONSULV 0.6.3
ENV CONSUL consul_$CONSULV_linux_amd64
RUN wget https://releases.hashicorp.com/consul/$CONSULV/$CONSUL.zip 
RUN unzip $CONSUL.zip -d $BIN_DIR

RUN consul agent
RUN curl localhost:8500/v1/catalog/nodes



# # # # ==== MUNGE
# RUN apt-get install -y --no-install-recommends libmunge-dev libmunge2 munge

# # # # add MUNGE RSA key
# ADD munge.key /etc/munge/


# # # # ==== SLURM
# RUN apt-get install -y --no-install-recommends slurm-llnl





# # # clean local package archive
RUN apt-get clean



# # # test MUNGE

# # RUN /usr/sbin/munged

# # RUN munge -n | unmunge

# RUN remunge


