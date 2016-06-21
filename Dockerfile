# # compute-node : a generic compute node image using Slurm and Munge

# # `docker-phusion-supervisor` contains:
# # * supervisord
# # * consul-template

FROM ocramz/docker-phusion-supervisor

# # update TLS-related stuff and install tools
RUN apt-get update && \
    apt-get -qq install -y --no-install-recommends ca-certificates debian-keyring debian-archive-keyring && \
    apt-key update && \
    apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends make gcc bzip2 unzip gfortran \
                                                   wget curl python pkg-config perl\
						   libmunge-dev libmunge2 munge\
						   slurm-llnl && \
    apt-get clean
						   

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
ENV TMP $HOME/tmp
# ENV CONSULTMP $TMP/consul
ENV CERTS_DIR $HOME/.certs
ENV ETC $HOME/etc

# # Create directories
RUN mkdir -p $LOCAL_DIR
RUN mkdir -p $BIN_DIR
RUN mkdir -p $SRC_DIR
RUN mkdir -p $TMP
RUN mkdir -p $ETC

# RUN mkdir -p $CONSULTMP
RUN mkdir -p $CERTS_DIR
RUN mkdir -p $ETC/consul.d

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



# # # # ==== Consul

# ENV CONSUL_VER 0.6.3

# RUN wget https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip 
# RUN unzip consul_0.6.3_linux_amd64.zip -d $BIN_DIR

# RUN consul --version

# # test Consul (NB: stop with C-c)
# RUN consul agent -server -bootstrap -data-dir $CONSULTMP
# RUN curl localhost:8500/v1/catalog/nodes





# # # ==== MUNGE

# # # add MUNGE RSA key
# ADD munge.key /etc/munge/





# # # ==== SLURM




# # # clean local package archive



# # # test MUNGE

# # RUN /usr/sbin/munged

# # RUN munge -n | unmunge

# RUN remunge






# # # === expose TCP/IP ports

EXPOSE 22
EXPOSE 80
EXPOSE 2375  # 2376 for TLS