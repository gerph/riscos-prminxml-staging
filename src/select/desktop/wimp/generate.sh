#!/bin/bash
##
# Generates the diagrams from source files.

set -e

ditaa --no-separation --svg iconpriorities.ditaa iconpriorities.svg
ditaa --no-separation iconpriorities.ditaa iconpriorities.png
