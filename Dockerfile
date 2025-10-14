FROM ubuntu:24.04@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS builder
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
  unzip \
  locales
RUN ln -s /usr/bin/clang-18 /usr/bin/clang
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8 FUZION_REPRODUCIBLE_BUILD="true" PRECONDITIONS="true" POSTCONDITIONS="true"
WORKDIR /fzweb
COPY . .
WORKDIR /fzweb/fuzion
RUN make
WORKDIR /fzweb/flang_dev
RUN make DITAA='java -jar /usr/share/ditaa/ditaa.jar' FZ='/fzweb/fuzion/build/bin/fz' build
WORKDIR /fzweb
RUN /fzweb/fuzion/build/bin/fz -classes -verbose=2 -unsafeIntrinsics=on -modules=http,lock_free,uuid,java.base,java.desktop,java.datatransfer,java.xml,java.logging,java.security.sasl,webserver -sourceDirs=src run
RUN sed -i 's|-cp "|-cp "/fzweb/classes:|g' run


FROM ubuntu:24.04@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS runner
RUN apt-get update && apt-get -y --no-install-recommends install \
  locales \
  openjdk-21-jre-headless
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8 PATH="/fzweb/fuzion/build/bin:${PATH}" PRECONDITIONS="true" POSTCONDITIONS="true"
COPY --from=builder /fzweb /fzweb
WORKDIR /fzweb
RUN ln -sf /fzweb/flang_dev/content
RUN ln -sf /fzweb/flang_dev/templates
ENTRYPOINT /fzweb/run
EXPOSE 8080
