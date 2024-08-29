{ lib
, stdenv
, callPackage
, file
, gcc
, gccStdenv
, gnumake
, zlib
, coreutils-full
, glibc
, findutils
, bash
, gnugrep
, gnused
, diffutils
, gawk
, curl
, gnutar
, bzip2
, texinfoInteractive
, nettools

, pkgsrcSrc
, pkgsrcVersion
}:
let
  pkgsrc-bootstrap = stdenv.mkDerivation {
    pname = "pkgsrc-bootstrap";
    version = pkgsrcVersion;
    src = pkgsrcSrc;

    buildInputs = [
      file
      gnumake
      zlib
      gcc
      gccStdenv

      coreutils-full
      glibc
      findutils
      bash
      gnugrep
      gnused
      diffutils
      bzip2
      gnutar
      texinfoInteractive
      gawk
      curl

      nettools
    ];

    buildPhase = ''
      UNAME=$(echo "${coreutils-full}/bin/uname" | sed -r 's/\//\\\//g')
      sed "s/UNAME=echo Unknown/UNAME=$UNAME/g" -i mk/bsd.prefs.mk
      cd bootstrap
      ./bootstrap --workdir $(pwd)/work --prefix $(pwd)/res --unprivileged
      rm -rf ./work
      cd ..
    '';

    installPhase = ''
      mkdir $out
      cp -r bootstrap/res/* $out/
    '';

    #TOOLS_PLATFORM.autopoint?=	${_path}/autopoint
    "TOOLS_PLATFORM.basename" = "${coreutils-full}/bin/basename";
    "TOOLS_PLATFORM.bash" = "${bash}/bin/bash";
    #TOOLS_PLATFORM.bison?=		${_path}/bison
    "TOOLS_PLATFORM.bzcat" = "${bzip2}/bin/bzcat";
    "TOOLS_PLATFORM.bzip2" = "${bzip2}/bin/bzip2";
    "TOOLS_PLATFORM.cat" = "${coreutils-full}/bin/cat";
    "TOOLS_PLATFORM.chgrp" = "${coreutils-full}/bin/chgrp";
    "TOOLS_PLATFORM.chmod" = "${coreutils-full}/bin/chmod";
    "TOOLS_PLATFORM.chown" = "${coreutils-full}/bin/chown";
    "TOOLS_PLATFORM.cmp" = "${diffutils}/bin/cmp";
    "TOOLS_PLATFORM.cp" = "${coreutils-full}/bin/cp";
    #TOOLS_PLATFORM.csh?=		${_path}/tcsh
    "TOOLS_PLATFORM.curl" = "${curl}/bin/curl";
    "TOOLS_PLATFORM.cut" = "${coreutils-full}/bin/cut";
    "TOOLS_PLATFORM.date" = "${coreutils-full}/bin/date";
    "TOOLS_PLATFORM.diff" = "${diffutils}/bin/diff";
    "TOOLS_PLATFORM.diff3" = "${diffutils}/bin/diff3";
    "TOOLS_PLATFORM.dirname" = "${coreutils-full}/bin/dirname";
    #TOOLS_PLATFORM.egrep?=		${_path}/egrep
    "TOOLS_PLATFORM.env" = "${coreutils-full}/bin/env";
    "TOOLS_PLATFORM.expr" = "${coreutils-full}/bin/expr";
    #TOOLS_PLATFORM.fgrep?=		${_path}/fgrep
    "TOOLS_PLATFORM.file" = "${file}/bin/file";
    "TOOLS_PLATFORM.find" = "${findutils}/bin/find";
    #TOOLS_PLATFORM.gettext?=	${_path}/gettext
    #TOOLS_PLATFORM.git?=		${_path}/git
    #TOOLS_PLATFORM.m4?=		${_path}/m4
    #TOOLS_PLATFORM.gmake?=		${_path}/make
    "TOOLS_PLATFORM.gawk" = "${gawk}/bin/gawk";
    "TOOLS_PLATFORM.grep" = "${gnugrep}/bin/grep";
    #TOOLS_PLATFORM.groff?=		${_path}/groff
    "TOOLS_PLATFORM.sed" = "${gnused}/bin/sed";
    #TOOLS_PLATFORM.gsoelim?=	${_path}/soelim
    "TOOLS_PLATFORM.tar" = "${gnutar}/bin/tar";
    #TOOLS_PLATFORM.gunzip?=		${_path}/gunzip -f
    #TOOLS_PLATFORM.gzcat?=		${_path}/zcat
    #TOOLS_PLATFORM.gzip?=		${_path}/gzip -nf ${GZIP}
    "TOOLS_PLATFORM.head" = "${coreutils-full}/bin/head";
    "TOOLS_PLATFORM.hostname" = "${nettools}/bin/hostname";
    "TOOLS_PLATFORM.id" = "${coreutils-full}/bin/id";
    #TOOLS_PLATFORM.ident?=		${_path}/ident
    "TOOLS_PLATFORM.install" = "${coreutils-full}/bin/install";
    "TOOLS_PLATFORM.install-info" = "${texinfoInteractive}/bin/install-info";
    "TOOLS_PLATFORM.ldconfig" = "${glibc}/bin/ldconfig";
    "TOOLS_PLATFORM.ln" = "${coreutils-full}/bin/ln";
    "TOOLS_PLATFORM.ls" = "${coreutils-full}/bin/ls";
    #TOOLS_PLATFORM.mail?=		${_path}/mail	# Debian, Slackware, SuSE
    #TOOLS_PLATFORM.makeinfo?=	${_path}/makeinfo
    #TOOLS_PLATFORM.mandoc?=		${_path}/mandoc
    "TOOLS_PLATFORM.mkdir" = "${coreutils-full}/bin/mkdir -p";
    "TOOLS_PLATFORM.mktemp" = "${coreutils-full}/bin/mktemp";
    #TOOLS_PLATFORM.msgconv?=	${_path}/msgconv
    #TOOLS_PLATFORM.msgfmt?=		${_path}/msgfmt
    #TOOLS_PLATFORM.msgmerge?=	${_path}/msgmerge
    "TOOLS_PLATFORM.mv" = "${coreutils-full}/bin/mv";
    "TOOLS_PLATFORM.nice" = "${coreutils-full}/bin/nice";
    #TOOLS_PLATFORM.nroff?=		${_path}/nroff
    #TOOLS_PLATFORM.openssl?=	${_path}/openssl
    "TOOLS_PLATFORM.printf" = "${coreutils-full}/bin/printf";
    "TOOLS_PLATFORM.pwd" = "${coreutils-full}/bin/pwd";
    "TOOLS_PLATFORM.readlink" = "${coreutils-full}/bin/readlink";
    "TOOLS_PLATFORM.realpath" = "${coreutils-full}/bin/realpath";
    "TOOLS_PLATFORM.rm" = "${coreutils-full}/bin/rm";
    "TOOLS_PLATFORM.rmdir" = "${coreutils-full}/bin/rmdir";
    #TOOLS_PLATFORM.sdiff?=		${_path}/sdiff
    "TOOLS_PLATFORM.sh" = "${bash}/bin/sh";
    "TOOLS_PLATFORM.sleep" = "${coreutils-full}/bin/sleep";
    #TOOLS_PLATFORM.soelim?=		${_path}/soelim
    "TOOLS_PLATFORM.sort" = "${coreutils-full}/bin/sort";
    "TOOLS_PLATFORM.strip" = "${coreutils-full}/bin/strip";
    "TOOLS_PLATFORM.tail" = "${coreutils-full}/bin/tail";
    #TOOLS_PLATFORM.tbl?=		${_path}/tbl
    "TOOLS_PLATFORM.tee" = "${coreutils-full}/bin/tee";
    "TOOLS_PLATFORM.touch" = "${coreutils-full}/bin/touch";
    "TOOLS_PLATFORM.tr" = "${coreutils-full}/bin/tr";
    "TOOLS_PLATFORM.tsort" = "${coreutils-full}/bin/tsort";
    "TOOLS_PLATFORM.uniq" = "${coreutils-full}/bin/uniq";
    "TOOLS_PLATFORM.wc" = "${coreutils-full}/bin/wc";
    #TOOLS_PLATFORM.wget?=		${_path}/wget
    "TOOLS_PLATFORM.xargs" = "${findutils}/bind/xargs -r";
    #TOOLS_PLATFORM.xgettext?=	${_path}/xgettext
    #TOOLS_PLATFORM.yacc?=		${_path}/yacc
    #TOOLS_PLATFORM.xz?=		${_path}/xz
    #TOOLS_PLATFORM.xzcat?=		${_path}/xzcat
  };

  mkPkgsrcCdnPackage = { pname, version, arch, outputHash, netbsdVersion ? "10.0_2024Q2" }: stdenv.mkDerivation {
    inherit pname;
    inherit version;
    src = ./.;

    doCheck = false;
    dontFixup = true;
    "PKG_PATH" = "http://cdn.NetBSD.org/pub/pkgsrc/packages/NetBSD/${arch}/${netbsdVersion}/All";

    buildInputs = [ pkgsrc-bootstrap ];

    buildPhase = ''
      mkdir -p dest/usr/pkg/pkgdb
      dest=$(pwd)/dest
      ${pkgsrc-bootstrap}/bin/pkg_add -v -m ${arch} -K $dest/usr/pkg/pkgdb -p $dest/usr/pkg -I -f ${pname}
    '';

    installPhase = ''
      mkdir $out
      cp -r dest/* $out/
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    inherit outputHash;
  };

  mkPkgSet = { pname, version, setName, netbsdPkgs, netbsdRelease }: stdenv.mkDerivation {
    inherit pname;
    inherit version;
    srcs = netbsdPkgs;
    sourceRoot = ".";

    dontFixup = true;
    buildInputs = [
      netbsdRelease
      pkgsrc-bootstrap
    ];

    buildPhase = ''
      dest=$(pwd)/res
      mkdir $dest
      for i in $(pwd)/*; do
        if [ -d $i ]; then
          if [ "$i" != "$dest" ]; then
            cp -r $i/* $dest/
          fi
        fi
      done
      mkdir -p $dest/etc/mtree
      ${pkgsrc-bootstrap}/bin/pkg_admin -v -K $dest/usr/pkg/pkgdb rebuild
      mtree=${netbsdRelease}/tools/mtree/mtree
      run_fhs=${netbsdRelease}/run
      $run_fhs "$mtree -p $dest -c -S -k sha256,uname,gname,mode,size,link,tags,optional | $mtree -CS -k all > $dest/etc/mtree/set.${setName}"
      sed -E -i 's/uname=nixbld/uname=root/' $dest/etc/mtree/set.${setName}
      sed -E -i 's/gname=nixbld/gname=wheel/' $dest/etc/mtree/set.${setName}
      sed -E -i "s/(\.\/etc\/mtree\/set\.apps.*)size.*$/\1/g" $dest/etc/mtree/set.${setName}
    '';

    installPhase = ''
      mkdir $out
      cp -r ./res/* $out/
    '';
  };

in
{
  inherit pkgsrc-bootstrap;
  inherit mkPkgsrcCdnPackage;
  inherit mkPkgSet;
  pkgs = callPackage ./pkgs.nix { mkPkgsrcPackage = mkPkgsrcCdnPackage; };
}
