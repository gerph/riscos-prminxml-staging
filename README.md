# RISC OS supplementary documentation

## Introduction

This repository hold supplementary documentation in PRM-in-XML format.
It is a staging area for conversions of documentation.

## Building the documentation

With docker:

    docker run -it --rm -v$PWD:/work -w /work ubuntu:18.04 ./build.sh

This will install all the necessary components and perform the build.
The build will produce results in the `output` directory, as HTML and
PDF.

