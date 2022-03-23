# RISC OS supplementary documentation

## Introduction

This repository hold supplementary documentation in PRM-in-XML format.
It is a staging area for conversions of documentation.

## Building the documentation

Building the documentation can be performed on most modern POSIX systems with Docker.

With Docker:

    docker run -it --rm -v$PWD:/work -w /work ubuntu:18.04 ./build.sh

This will install all the necessary components and perform the build.
The build will produce results in the `output` directory, as HTML.

For PDF use, you should follow the [PrinceXML licensing](https://www.princexml.com/purchase/license_faq/) terms. For most use, you should be able to use the non-commercial license.
This can be indicated by setting the environment variable `PRINCEXML_I_HAVE_A_LICENSE`, thus:

    docker run -it --rm -v$PWD:/work -e PRINCEXML_I_HAVE_A_LICENSE=1 -w /work ubuntu:18.04 ./build.sh
