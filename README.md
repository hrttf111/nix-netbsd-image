# nix-netbsd-image
This flake contains tools which produce customized netbsd image which includes arbitrary files and packages.

## Description
In scope of image build following is performed:
 - Tools, kernel and release are built for netbsd from source code
 - Bootstrap for pkgsrc is built, later it can be used to install packages from CDN
 - Arbitrary packages are downloaded to be included in image
 - Arbitrary files are added to image
 - Bootable image is produced

## netbsd.nix
This file contains scripts and derivations which produce tools, kernel, release and default images (iso and live):
 - netbsd-fhs is FHS which is capable of building netbsd from sources
 - netbsd-tools is a package which contains compiled netbsd tools (compiler, linker, etc.). Those are cross-compiled binaries, which can be executed on host (likely amd64 Linux) to produce artifacts capable to run on target (amd64/i386 Netbsd)
 - netbsd-kernel contains compiled GENERIC netbsd kernel and related artifacts
 - netbsd-release create full netbsd release which contains all standard netbsd SW + tools + kernel + some custom scripts used by other derivations. This is the main package used by image building derivations and scripts
 - netbsd-iso is a default netbsd ISO, no custom content is included here
 - netbsd-live is a default LIVE netbsd image, no custom content is included here
It also exports functions which can be used to run arbitrary scripts in a netbsd build environment:
 - mkNetbsdFhsLive is a function which produces customized FHS derivations, could be used to manually debug build and for experimentation
 - mkNetbsdDerivation is a function which provides tools to create derivation with netbsd sources and FHS. It is a base functions which all other netbsd derivations use. It provide environment to work with netbsd sources in FHS
 - mkNetbsdImg is a function which creates a derivation with an access to netbsd code, FHS and pre-built netbsd-release. It contains everithing to create customized netbsd image

## pkgsrc
This directory contains NIX sources and scripts which build pkgsrc bootstrap, downloader for pre-built CDN packages and derivation which merges arbitrary number of packages into a single set. Provides following:
 - pkgsrc-bootstrap is a package which contains pkgsrc bootstrap; pkg_add, pkg_info, etc.
 - mkPkgsrcCdnPackage is a function which creates NIX derivation with a package content (already built) downloaded from CDN
 - mkPkgSet is a function which merges multiple packages into a single set (with a correctly populated pkgdb and mtree)
 - pkgs is a map which contains list of packages for different architectures. It is used later to install specific packages to image (using mkPkgSet)

## image
This directory contains functions which builds image and a patch for netbsd sources.
 - mkEmbeddedImage creates image based on following parameters:
    - nameSuffix is an arbitrary string added to an image name (usually contains info about architecture and machine compatible with image)
    - netbsdRelease is a valid netbsd release derivation
    - pkgSets is a list of custom sets to be installed to image (each set must contain valid mtree)
    - diskType is which will be used when creating fstab for (sd for USB images and wd for fixed disks)
    - compress is true when image must be compressed after creation
    - extraSize is a free size space allocated in image (the value is in blocks)
    - minWrites can be used to minimize amount of writes when image is running (important when running image from USB flash driver or memory card)
    - defaultSets is a list of default netbsd sets to be included into image
    - serialConsole may be true to enable serial console for bootloader
 - embedded.patch fixes few bugs related to creation of "embedded" image in netbsd. It also extends possible customization of produced image
mkEmbeddedImage merges "/etc/fstab" files found in custom sets.

## custom
Contains derivation which produce set with an arbitrary content. Content is inside "data" directory, it represents root fs of a custom netbsd image. All files, except files for specific user in "/home", belong to root:wheel. Files in "/home/XXX" are correctly owned by user:group, user and group must be defined in "/etc/passwd" and "/etc/groups". Derivation also creates valid "spwd.db" and "pwd.db".

# Usage
To create i386 image: nix build ./#netbsd-i386.embedded-image
To create amd64 image: nix build ./#netbsd-amd64.embedded-image
Script "start-img" may be used to run image in qemu.
Default passwords in custom image:
For "root" user -> root
For "admin" user -> admin
