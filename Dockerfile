FROM ubuntu:latest

# Update the package lists
RUN dpkg --add-architecture i386 && apt-get update && apt-get upgrade -y

# Install the necessary tools
RUN apt-get install -y autoconf build-essential curl git make unzip wget wine wine32

# Install Pasmo
RUN wget https://pasmo.speccy.org/bin/pasmo-0.5.5.tar.gz \
    && tar -xvzf pasmo-0.5.5.tar.gz \
    && cd pasmo-0.5.5 && ./configure && make && make install \
    && cd ..

# Install libdsk
RUN wget https://www.seasip.info/Unix/LibDsk/libdsk-1.5.19.tar.gz \
    && tar -xvzf libdsk-1.5.19.tar.gz \
    && cd libdsk-1.5.19 && ./configure && make && make install \
    && cd ..

# Install mkp3fs, specform and tapget utilities
RUN wget http://www.seasip.info/ZX/taptools-1.0.8.tar.gz \
    && tar -xvzf taptools-1.0.8.tar.gz \
    && cd taptools-1.0.8 && ./configure && make && make install \
    && cd ..

# Install apack compressor
RUN wget http://www.smspower.org/maxim/uploads/SMSSoftware/aplib12.zip \
    && unzip aplib12.zip \
    && echo "wine /appack.exe c \$@" > /usr/local/bin/apack \
    && chmod +x /usr/local/bin/apack

# Install zmakebas
RUN git clone https://github.com/z00m128/zmakebas \
    && cd zmakebas && make && make install \
    && cd ..

# Install hdfmonkey
RUN git clone https://github.com/gasman/hdfmonkey \
    && cd hdfmonkey && autoheader && aclocal && autoconf && automake -a && ./configure && make && make install \
    && cd ..

# Install dskgen
RUN git clone https://github.com/AugustoRuiz/dskgen \
    && cd dskgen && make -f Makefile.others && cp bin/dskgen /usr/local/bin/dskgen \
    && cd ..

# Install fill16k
RUN git clone https://github.com/fjpena/sword-of-ianna-zx.git \
    && gcc /sword-of-ianna-zx/tools/fill16k.c -o /usr/local/bin/fill16k

# Update library load config
RUN ldconfig

# Create directory for source code

RUN mkdir /src

WORKDIR /src/src

ENTRYPOINT ["bash"]

CMD ["-i"]

# Usage: docker run -v $(pwd):/src -it ianna
# cd src/src
# make