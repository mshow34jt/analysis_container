FROM centos:7 AS build
#RUN yum update -y && yum group install -y "Development Tools" && \
RUN yum update -y && yum install -y gcc make && \
    yum install -y mariadb-libs \
    mysql-devel \
    git && \
    yum clean all

WORKDIR /source

RUN git clone https://github.com/mshow34jt/LDMSparsers && \
  git clone https://github.com/mshow34jt/jobmon && \
  cd LDMSparsers/src/parse_slurm && \
  make

FROM centos:7 AS runner
#RUN yum update -y && \
RUN yum install -y mariadb-libs perl "perl(DBD::mysql)" perl-Thread-Queue && \
    mkdir -p /jobmon/bin && \
    yum clean all

COPY --from=build /source/LDMSparsers/src/parse_slurm/parse_slurm /jobmon/bin
COPY --from=build /source/LDMSparsers/src/vinsert/vinsert.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_meminfo/parse_meminfo.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/jcc/jcc.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_opa2/parse_opa2.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_lustre_client/parse_lustre_client.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_procnfs/parse_procnfs.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_procnetdev/parse_procnetdev.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_procstat_72/parse_procstat_72.pl   /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_gw_sysclassib/parse_gw_sysclassib.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_loadavg/parse_loadavg.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_lnet_stats/parse_lnet_stats.pl  /jobmon/bin
COPY --from=build /source/LDMSparsers/src/parse_procnet/parse_procnet.pl  /jobmon/bin
COPY --from=build /source/jobmon/bin/* /jobmon/bin/

COPY --from=build /source/jobmon/util/cron /etc/cron.d/ingest_cron

RUN chmod +x /jobmon/bin/*.sh && \
    chmod 644  /etc/cron.d/ingest_cron

CMD ["/bin/bash", "-c", "/jobmon/bin/init.sh"]

