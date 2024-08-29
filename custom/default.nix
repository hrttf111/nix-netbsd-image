{ lib
, stdenv
, netbsdRelease
}:
let
  # to generate password: pwhash -A argon2id,p=1,m=4096,t=7 -p
  mtree = "${netbsdRelease}/tools/mtree/mtree";
  pwd_mkdb = "${netbsdRelease}/tools/pwd_mkdb/pwd_mkdb";
  name = "custom";
  custom-set = stdenv.mkDerivation {
    pname = "netbsd-custom-set";
    version = "1.0";
    src = ./.;

    buildPhase = ''
      dest=$(pwd)/res
      mkdir -p $dest/etc/mtree
      run_fhs=${netbsdRelease}/run
      if [ -d $(pwd)/data ]; then
        cp -r $(pwd)/data/* $dest
        if [ -f $dest/etc/master.passwd ]; then
          $run_fhs "${pwd_mkdb} -d $dest $dest/etc/master.passwd"
          chmod 0600 $dest/etc/spwd.db
          chmod 0600 $dest/etc/master.passwd
        fi
      fi
      $run_fhs "${mtree} -p $dest -c -S -k sha256,uname,gname,mode,size,link,tags,optional | ${mtree} -CS -k all > $dest/etc/mtree/set.${name}"

      sed -E -i 's/uname=nixbld/uname=root/' $dest/etc/mtree/set.${name}
      sed -E -i 's/gname=nixbld/gname=wheel/' $dest/etc/mtree/set.${name}

      for user in $(pwd)/res/home/*; do
        username=$(basename $user)
        uid=$(cat $dest/etc/passwd | grep -e "^$username:" | awk -F ':' '{ print $3; }' 2> /dev/null)
        if [ -n "$uid" ]; then
          sed -E -i "s/(\.\/home\/)([[:alnum:]]+)(.*)uname=root(.*)/\1\2\3uid=$uid\4/g" $dest/etc/mtree/set.${name}
        fi
        gid=$(cat $dest/etc/group | grep -e "^$username:" | awk -F ':' '{ print $3; }' 2> /dev/null)
        if [ -n "$gid" ]; then
          sed -E -i "s/(\.\/home\/)([[:alnum:]]+)(.*)gname=wheel(.*)/\1\2\3gid=$gid\4/g" $dest/etc/mtree/set.${name}
        fi
      done

      sed -E -i "s/(\.\/etc\/mtree\/set\.custom.*)size.*$/\1/g" $dest/etc/mtree/set.${name}
    '';

    installPhase = ''
      mkdir $out
      cp -r $(pwd)/res/* $out/
    '';
  };
in
{
  inherit custom-set;
}
