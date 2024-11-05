# fzweb

## A webserver written in the Fuzion language.

> Please note that this webserver is work in progress, and that it is
> currently not possible to run it without access to files internal to
> Tokiwa Software.

---

<!--ts-->
   * [About](#about)
   * [Clone](#clone)
   * [Required Setup](#required-setup)
   * [Build and Run](#build-and-run)
<!--te-->

---

## About

This webserver is intended to replace our current Java-based webserver
for the [Fuzion website](https://fuzion-lang.dev/). It currently depends
on that Java-based webserver, which means it is currently impossible to
run without having access to this internal code. This is due to change
soon. Note however that the full website source code will likely be never
published.

## Clone

> Note that the webserver must be cloned into the parent directory of
> your Fuzion and `flang_dev` (this is the part internal to Tokiwa
> Software) clone.

    git clone https://github.com/tokiwa-software/fzweb.git

## Required Setup

1. Build Fuzion as usual, building all the modules (`make`).
2. In your `flang_dev` clone, build the `webserver.fum` module using
   `make /full/path/to/fuzion/build/modules/webserver.fum`.

## Build and Run

> Make sure `fz` is in your `$PATH`.

    cd fzweb
    make run_fz

To compile using the C backend and run the binary immediately:

    make run_fz_c
