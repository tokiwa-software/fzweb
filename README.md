# fzweb

## A webserver written in the Fuzion language.

> Please note that this webserver is work in progress.

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
for the [Fuzion website](https://fuzion-lang.dev/). It can be built and
run without any internal files, but the actual website content is not
public.

## Clone

> Note that the webserver must be cloned into the parent directory of
> your Fuzion clone.

    git clone https://github.com/tokiwa-software/fzweb.git

## Required Setup

1. Build Fuzion as usual, building all the modules (`make`).

## Build and Run

> Make sure `fz` is in your `$PATH`.

    cd fzweb
    make run_fz

To compile using the C backend and run the binary immediately:

    make run_fz_c
