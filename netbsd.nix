{ lib
, stdenv
, zlib
, buildFHSUserEnv
}:
args @ {arch, machine, version, kernel, netbsd-src, logLevel ? "0", ...}:
  let
    ####
    objLocation = "/build/obj";
    srcLocation = "${objLocation}/src";
    numThreads = args.numThreads or "$NIX_BUILD_CORES";
    buildCmd = "./build.sh -U -O ${objLocation} -m ${machine} -a ${arch}";
    ####

    netbsd-fhs = buildFHSUserEnv {
      name = "netbsd-fhs";
      targetPkgs = pkgs: [
        pkgs.gcc
        pkgs.gnumake
        pkgs.gccStdenv
        pkgs.zlib
        pkgs.zlib.dev
      ];
      runScript = "/bin/bash -c";
    };

    mkNetbsdFhsLive = {objLocation, srcLocation, logLevel ? "0", numThreads ? "16"}:
    let
      buildCmd = "./build.sh -U -N ${logLevel} -O ${objLocation} -j${numThreads} -m ${machine} -a ${arch}";
    in
      buildFHSUserEnv {
        name = "netbsd-fhs-live-${arch}-${machine}-${version}";
        targetPkgs = pkgs: [
          pkgs.gcc
          pkgs.gnumake
          pkgs.gccStdenv
          pkgs.zlib
          pkgs.zlib.dev
        ];
        profile = ''
          export HOST_CFLAGS="-O -Wno-format-security -Wno-error=format-security -I/usr/include"
          export HOST_CPPFLAGS="-Wno-format-security -Wno-error=format-security -I/usr/include"
          export HOST_CXXFLAGS="-Wno-format-security -Wno-error=format-security -I/usr/include"
          alias build_tools="${buildCmd} tools"
          alias build_kernel="${buildCmd} kernel=GENERIC"
          alias build_release="${buildCmd} release"
          alias build_iso="${buildCmd} iso-image"
          alias build_img="${buildCmd} disk-image=GENERIC"
          alias build_live="${buildCmd} live-image"
          alias build_image="./distrib/utils/embedded/mkimage -D ${objLocation}/destdir.${machine} -K ${objLocation}/sys/arch/${machine}/compile/GENERIC/netbsd -h ${machine} -B le -r wd -x ./test-${machine}-image.img"
          alias build_params="${buildCmd} show-params"
          alias build_all="build_tools && build_kernel && build_release && build_iso"
          alias build_cmd="${buildCmd}"
          alias build_show="echo ${buildCmd}"
          cd ${srcLocation}
        '';
        runScript = "/bin/bash -l";
    };

    mkNetbsdDerivation = {pname, buildInputs, buildPhase, installPhase}: stdenv.mkDerivation {
      pname = "${pname}-${arch}-${machine}";
      inherit version;
      src = netbsd-src;

      doCheck = false;
      dontFixup = true;

      buildInputs = [
        zlib
        zlib.dev
        netbsd-fhs
      ] ++ buildInputs;

      "HOST_CFLAGS" = "-O -Wno-format-security -Wno-error=format-security -I/usr/include";
      "HOST_CPPFLAGS" = "-Wno-format-security -Wno-error=format-security -I/usr/include";
      "HOST_CXXFLAGS" = "-Wno-format-security -Wno-error=format-security -I/usr/include";

      "arch" = "${arch}";
      "machine" = "${machine}";
      "srcLocation" = "${srcLocation}";
      "objLocation" = "${objLocation}";
      "linksPath" = "/build/links";
      "fhsPath" = "${netbsd-fhs}/bin/${netbsd-fhs.name}";

      buildPhase = ''
        copy_src() {
          local name="$1"
          local src=$2
          local dst=$3
          echo "Copy $src/$name to $dst/$name"
          if [ -e $dst/$name ]; then
            rm $dst/$name
          fi
          cp -r $src/$name $dst
          chmod -R +w $dst/$name
          chown -R nixbld:nixbld $dst/$name
        }

        ln_dir() {
          local ln_from=$1
          local ln_to=$2
          for i in $ln_from/*; do
            echo "$i to $ln_to/$(basename $i)"
            echo $ln_to/$(basename $i) >> $linksPath
            ln -s $i $ln_to/$(basename $i)
          done
        }

        run_fhs() {
          echo $fhsPath "$buildCmd $@"
          $fhsPath "$@"
        }

        build_netbsd() {
          run_fhs "$buildCmd $1"
        }

        override_build_cmd() {
          buildCmd="${buildCmd} -N $1 -j$2"
        }

        buildCmd="${buildCmd} -N ${logLevel} -j${numThreads}"

        mkdir $objLocation
        mkdir $srcLocation
        mv ./* $srcLocation
        cd $srcLocation
        ####
        echo "Patch zlib location"
        ZLIB=$(echo "${zlib}/lib" | sed -r 's/\//\\\//g')
        ZLIBINC=$(echo "${zlib.dev}/include" | sed -r 's/\//\\\//g')
        sed "s/ZLIB = @zlibdir@ -lz/ZLIB = -L$ZLIB -lz/g" -i external/gpl3/gcc.old/dist/gcc/Makefile.in
        sed "s/ZLIBINC = @zlibinc@/ZLIBINC = -I $ZLIBINC/g" -i external/gpl3/gcc.old/dist/gcc/Makefile.in
        sed "s/ZLIB = @zlibdir@ -lz/ZLIB = -L$ZLIB -lz/g" -i external/gpl3/gcc/dist/gcc/Makefile.in
        sed "s/ZLIBINC = @zlibinc@/ZLIBINC = -I $ZLIBINC/g" -i external/gpl3/gcc/dist/gcc/Makefile.in
        ####
        ${buildPhase}
        rm -rf $srcLocation
      '';

      installPhase = ''
        mkdir $out
        if [ -f $linksPath ]; then
          for i in $(cat linksPath); do
            if [ -L $i ]; then
              echo "rm link $i"
              rm $i
            fi
          done
        fi
        ${installPhase}
      '';
    };

    mkNetbsdImg = args @ {pname, buildPhase, installPhase, netbsdRelease, patches ? [], ...}: lib.overrideDerivation (mkNetbsdDerivation {
      inherit pname;
      buildInputs = (args.buildInputs or []) ++ [ netbsdRelease ];
      buildPhase = ''
        ln_dir ${netbsdRelease} $objLocation
        copy_src distrib ${netbsdRelease} $objLocation
        copy_src releasedir ${netbsdRelease} $objLocation
        copy_src $(basename ${netbsdRelease}/tooldir*) ${netbsdRelease} $objLocation
        ${buildPhase}
      '';
      inherit installPhase;
    }) (old: {
      inherit patches;
      srcs = (args.src or []) ++ [old.src];
    });

    netbsd-tools = mkNetbsdDerivation {
      pname = "netbsd-tools";

      buildInputs = [];

      buildPhase = ''
        build_netbsd tools
      '';

      installPhase = ''
        cp -r $objLocation/* $out
      '';
    };

    netbsd-kernel = mkNetbsdDerivation {
      pname = "netbsd-kernel";

      buildInputs = [ netbsd-tools ];

      buildPhase = ''
        ln_dir ${netbsd-tools} $objLocation
        build_netbsd "kernel=${kernel}"
      '';

      installPhase = ''
        cp -r $objLocation/* $out
      '';
    };

    netbsd-release = mkNetbsdDerivation {
      pname = "netbsd-release";

      buildInputs = [
        netbsd-tools
        netbsd-kernel
      ];

      buildPhase = ''
        copy_src sys ${netbsd-kernel} $objLocation
        copy_src tools ${netbsd-tools} $objLocation
        copy_src $(basename ${netbsd-tools}/tooldir*) ${netbsd-tools} $objLocation
        build_netbsd release
      '';

      installPhase = ''
        cp -r $objLocation/* $out
        echo "#!/bin/sh" > $out/run
        echo "$fhsPath \"\$@\"" >> $out/run
        chmod +x $out/run
        printf "$fhsPath" > $out/fhs
      '';
    };

    netbsd-iso = mkNetbsdImg {
      pname = "netbsd-iso";
      buildPhase = ''
        build_netbsd iso-image
      '';
      installPhase = ''
        cp -r $objLocation/releasedir/images/*.iso $out
      '';
      netbsdRelease = netbsd-release;
    };

    netbsd-live = mkNetbsdImg {
      pname = "netbsd-live";
      buildPhase = ''
        build_netbsd live-image
      '';
      installPhase = ''
        cp $objLocation/distrib/i386/liveimage/emuimage/*.img $out
      '';
      netbsdRelease = netbsd-release;
    };

  in
  {
    inherit mkNetbsdFhsLive;
    inherit mkNetbsdDerivation;
    inherit mkNetbsdImg;

    inherit netbsd-fhs;
    inherit netbsd-tools;
    inherit netbsd-kernel;
    inherit netbsd-release;
    inherit netbsd-iso;
    inherit netbsd-live;
  }
