from ubuntu:14.04
maintainer Thomas Guyard <t.guyard@gigatribe.com>

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y g++ git make libboost1.54-all-dev libssl-dev cmake 

RUN apt-get install -y pkg-config doxygen

RUN cd /root                                          && \
    git clone https://github.com/gigagg/GiGaSdk.git && \
    cd GiGaSdk                                        && \
    git submodule update --init 

WORKDIR /root/GiGaSdk

# compiling casablanca
RUN cd vendors/casablanca/Release/      && \
    mkdir build.release                 && \
    cd build.release/                   && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cd ../../..

WORKDIR /root/GiGaSdk/vendors

# compiling crypto++      && \
RUN cd cryptopp/crypto++/ && \
    make                  && \
    cd ../..

# compiling/installing libcurl
RUN cd curl           && \
    mkdir build       && \
    cd build          && \
    cmake ..          && \
    make              && \
    sudo make install && \
    cd ../..

# compiling curlcpp
RUN cd curlcpp/build && \
    cmake ..         && \
    make             && \
    cd ../..

RUN cd casablanca/Release/build.release && \
    make && \
    make install

# compiling/installing GiGaSdk
RUN cd ../build       && \
    cmake ..          && \
    make              && \
    sudo make install

RUN ldconfig

ENTRYPOINT ["/usr/local/bin/GiGaSdk"]
