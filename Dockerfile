# builder

FROM ubuntu:24.04@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS builder
RUN apt-get update && apt-get -y --no-install-recommends install \
  openjdk-25-jdk-headless \
  git \
  make \
  patch \
  libgc1 \
  libgc-dev \
  shellcheck \
  asciidoc \
  asciidoctor \
  ruby-asciidoctor-pdf \
  antlr4 \
  clang-18 \
  wget \
  ditaa \
  inkscape \
  unzip \
  locales \
  maven \
  libwolfssl-dev \
  libwolfssl42t64 \
  libsodium23 \
  libsodium-dev
RUN ln -s /usr/bin/clang-18 /usr/bin/clang
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8 FUZION_REPRODUCIBLE_BUILD="true" PRECONDITIONS="true" POSTCONDITIONS="true"
WORKDIR /fzweb
COPY . .
WORKDIR /fzweb/fuzion
RUN make no-java build/fuzion.ebnf
WORKDIR /fzweb/flang_dev/rrd-antlr4
RUN sed -i 1,3d src/main/resources/railroad-diagram.css
RUN mvn clean package
WORKDIR /fzweb/flang_dev
RUN make DITAA='java -jar /usr/share/ditaa/ditaa.jar' FZ='/fzweb/fuzion/build/bin/fz' FUZION_HOME='/fzweb/fuzion/build' build
WORKDIR /fzweb
RUN /fzweb/fuzion/build/bin/fz -classes -JLibraries="wolfssl sodium" -verbose=2 -debug=0 -modules=http,lock_free,uuid,mail,crypto,nom,web -sourceDirs=src run


# runner


FROM ubuntu:24.04@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS runner
RUN apt-get update && apt-get -y --no-install-recommends install \
  locales \
  openjdk-25-jre-headless \
  libwolfssl-dev \
  libwolfssl42t64 \
  libsodium23 \
  libsodium-dev \
  openssh-client
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8 PATH="/fzweb/fuzion/build/bin:${PATH}"
COPY --from=builder /fzweb /fzweb
WORKDIR /fzweb
RUN ln -sf /fzweb/flang_dev/content
RUN ln -sf /fzweb/flang_dev/templates
ENTRYPOINT /fzweb/run
EXPOSE 8080
