{ lib
, stdenv
, mkNetbsdImg
}:
let
  mkEmbeddedImage = {
    nameSuffix,
    netbsdRelease,
    pkgSets,
    diskType ? "wd",
    compress ? false,
    extraSize ? 32,
    minWrites ? false,
    defaultSets ? [],
    serialConsole ? false
  }:
  let
    allSets = lib.strings.concatMapStringsSep " " toString pkgSets;
    kernelType = "GENERIC";
    imageName = "netbsd-live-";
    endian = "-B le";
    gz = if compress then ".gz" else "";
    mw = if minWrites then "-m" else "";
    defaultSetStr = "base etc man misc modules rescue text";
    defaultSetsStr = if defaultSets == [] then defaultSetStr else lib.strings.concatStringsSep " " defaultSets;
    fsArgs = "rw,log";
    installbootArgs = if serialConsole then "-o console=com0,speed=19200" else "";
  in mkNetbsdImg {
    pname = "netbsd-embedded-image-${nameSuffix}";
    buildPhase = ''
      echo "Start image build"
      export MKDTB="no"
      export TOOL_DISKLABEL=$objLocation/tools/disklabel/disklabel
      export TOOL_FDISK=$objLocation/tools/fdisk/fdisk
      export TOOL_MAKEFS=$objLocation/tools/makefs/makefs
      export TOOL_INSTALLBOOT="$objLocation/tools/installboot/installboot"
      export DEFAULT_SETS="${defaultSetsStr}"
      export CUSTOM_SET=/build/set.custom
      export CUSTOM_SET_DIR="/build/sets"
      export EXTRA_SIZE=${toString extraSize}
      export FS_ARGS="${fsArgs}"
      export FS_SCRIPT=/build/fs_script
      export INSTALLBOOT_ARGS="${installbootArgs}"
      mkdir -p /build/sets
      touch /build/fstab_addition
      for i in ${allSets}; do
        for j in $i/etc/mtree/*; do
          echo "Copy set $j"
          cat $j >> $CUSTOM_SET
        done
        cp -r $i/* /build/sets/
        chmod -R +w /build/sets/
        if [ -f $i/etc/fstab ]; then
          echo "Merge fstab"
          rm /build/sets/etc/fstab
          cat $i/etc/fstab >> /build/fstab_addition
        fi
      done
      if [ -f $CUSTOM_SET ]; then
        cat $CUSTOM_SET | grep -e "/etc/fstab" -v > /build/tmp1
        mv /build/tmp1 $CUSTOM_SET
      fi
      echo "#!/bin/sh" > $FS_SCRIPT
      echo "cat /build/fstab_addition >> \$1/etc/fstab" >> $FS_SCRIPT
      echo "cat \$1/etc/fstab" >> $FS_SCRIPT
      chmod +x $FS_SCRIPT
      copy_src destdir.$machine ${netbsdRelease} $objLocation
      chmod +w $objLocation/destdir.$machine/etc/rc.conf
      run_fhs "$srcLocation/distrib/utils/embedded/mkimage \
        -D $objLocation/destdir.$machine \
        -K $objLocation/sys/arch/$machine/compile/${kernelType}/netbsd \
        -h $machine \
        ${endian} \
        ${mw} \
        -r ${diskType} \
        -x /build/${imageName}$machine.img${gz}"
    '';
    installPhase = ''
      ls -lah /build/*.img${gz}
      cp /build/*.img${gz} $out/
    '';
    inherit netbsdRelease;
    patches = [ ./embedded.patch ];
  };
in
{
  inherit mkEmbeddedImage;
}
