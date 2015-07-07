FROM library/golang:1.4.2
RUN go get github.com/tsenart/vegeta
RUN go install github.com/tsenart/vegeta
ADD ./benchmark.sh /go/bin/benchmark.sh
RUN chmod 0775 /go/bin/benchmark.sh
#ENTRYPOINT ["/go/bin/benchmark.sh"]
