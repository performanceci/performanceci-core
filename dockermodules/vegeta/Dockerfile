FROM ubuntu:12.04
RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy build-essential curl git
RUN curl -s https://go.googlecode.com/files/go1.2.src.tar.gz | tar -v -C /usr/local -xz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1
ENV PATH /usr/local/go/bin:$PATH
ENV GOROOT /usr/local/go
ENV GOPATH /opt/goroot
RUN mkdir /opt/goroot
RUN go get github.com/tsenart/vegeta
RUN go install github.com/tsenart/vegeta
ADD ./benchmark.sh /opt/benchmark.sh
RUN chmod 0775 /opt/benchmark.sh
#ENTRYPOINT ["/opt/benchmark.sh"]
