# Packer Build

## Shared Components

This directory contains the content that's shared across all of the builds. The general idea has been that one configuration will be used to build all images so they're all generally the same.

## Contents

`files`: Shared/common files that are generally copied up to the remote intact. Use these sparingly, it's recommended that post-build automation drives local machine configurations, the base builds should be as generic as possible.

`kickstart`: Shared Kickstart configurations that are fed to the Packer installer when it calls Anaconda.

`scripts`: Post-build scripts.

`vars`: Variables shared across all builds.



*Note: as with all documentation these are provided best effort and are immediately out of date so take things here with a bucket of grains of salt. The code itself is the defacto "source of truth" for all things.*
