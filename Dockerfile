FROM ubuntu:24.04@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS builder
WORKDIR /fzweb
COPY . .
RUN apt-get update && apt-get -y --no-install-recommends install \
  openjdk-21-jdk-headless \
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
  unzip
RUN ln -s /usr/bin/clang-18 /usr/bin/clang
ENV FUZION_REPRODUCIBLE_BUILD="true" PRECONDITIONS="true" POSTCONDITIONS="true"
WORKDIR /fzweb/fuzion
RUN make
WORKDIR /fzweb/flang_dev
RUN make DITAA='java -jar /usr/share/ditaa/ditaa.jar' /fzweb/fuzion/build/modules/webserver.fum
WORKDIR /fzweb
RUN /fzweb/fuzion/build/bin/fz -classes -verbose=2 -unsafeIntrinsics=on -modules=http,lock_free,uuid,java.base,java.desktop,java.datatransfer,java.xml,java.logging,java.security.sasl,webserver -sourceDirs=src run
RUN sed -i 's|-cp "|-cp "/fzweb/flang_dev/classes:|g' webserver


FROM ubuntu:24.04@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS runner
COPY --from=builder /fzweb /fzweb
RUN apt-get update && apt-get -y --no-install-recommends install \
  locales \
  openjdk-21-jre-headless
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8 PATH="/fzweb/fuzion/build/bin:${PATH}" PRECONDITIONS="true" POSTCONDITIONS="true"
WORKDIR /fzweb
ENTRYPOINT /fzweb/webserver
