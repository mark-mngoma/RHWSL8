FROM gcc:latest AS builder
RUN curl -L https://github.com/bmc/daemonize/archive/release-1.7.8.tar.gz -o daemonize.tar.gz
RUN tar -xpf daemonize.tar.gz && cd daemonize-* && sh configure && make && make install

FROM registry.redhat.io/rhel8/dotnet-31:latest
USER root

RUN dnf install -y hostname && dnf clean all
RUN curl -L https://github.com/arkane-systems/genie/releases/download/1.26/genie.tar.gz -o genie.tar.gz
RUN tar -xpf genie.tar.gz && cp -rpf systemd-genie/* / && \
    rm -rf systemd-genie genie.tar.gz && ln -sf /usr/lib/systemd/systemd /sbin/systemd

COPY --from=builder /usr/local/sbin/daemonize /usr/local/sbin/daemonize
COPY --from=builder /usr/local/share/man/man1/daemonize.1 /usr/local/share/man/man1/daemonize.1
COPY --from=builder /sbin/runuser /usr/local/sbin/runuser
