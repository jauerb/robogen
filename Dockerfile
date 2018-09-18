FROM ubuntu:16.04
RUN apt-get update && \
      apt-get install -y software-properties-common && \
      add-apt-repository -y ppa:george-edison55/cmake-3.x && \
      apt-get update && \
      apt-get install -y \
        automake \
        cmake build-essential 
RUN apt-get install -y \
        git \
        gnuplot \
        libboost-all-dev \
        libjansson-dev \
        libprotobuf-dev \
        libopenscenegraph-dev \
        libopenscenegraph100v5 \
        libpng-dev \
        libssl-dev \
        libtool \
        protobuf-compiler \
        qt5-default \
        qtscript5-dev \
        zlib1g \
        zlib1g-dev
ADD https://bitbucket.org/odedevs/ode/downloads/ode-0.14.tar.gz /deps/ode.tar.gz
RUN tar xf /deps/ode.tar.gz -C /deps && \
      mv /deps/ode-0.14 /deps/ode && \
      rm /deps/ode.tar.gz
WORKDIR /robogen
WORKDIR /deps/ode
RUN ./bootstrap && \
      ./configure --enable-double-precision --with-cylinder-cylinder=libccd && \
      make install -j$(nproc)
RUN mkdir /robogen/build
ADD ./src /robogen/src
ADD ./arduino /robogen/arduino
ADD ./build_utils /robogen/build_utils
ADD ./models /robogen/models
WORKDIR /robogen/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ../src && \
      make -j$(nproc)
ENV TERM=xterm
CMD ["/bin/bash"]
