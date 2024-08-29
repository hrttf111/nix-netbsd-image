{
  description = "Netbsd custom image builder";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      pkgsrc = pkgs.callPackage ./pkgsrc {
        pkgsrcSrc = pkgs.fetchgit { # pkgsrc-2024Q2
          url = "https://github.com/NetBSD/pkgsrc.git";
          rev = "79634e72d5ef56ab81b6f893c0833596024b772c";
          hash = "sha256-AQm9OeeEe/Z0o2LdWGR9TuPPjs3SCl+fr1smIDq9Vn8=";
        };
        pkgsrcVersion = "2024Q2";
      };
      mkNetbsd = pkgs.callPackage ./netbsd.nix {};
      netbsd-src = pkgs.fetchgit {
        url = "https://github.com/NetBSD/src.git";
        rev = "e03aeb26bc621b824d8902aba93413d09e762513";
        hash = "sha256-RvN7T4jQwnC5rAHq6C8dw0AFxiU0IZ8VepjpT2iXrss=";
      };

      #########################################################################

      mkNetbsdFull = {arch, machine, netbsdPkgs, mkAppsSet, mkCustomImage}: rec {
        netbsd10 = mkNetbsd {
          arch = machine;
          machine = arch;
          version = "10.0";
          kernel = "GENERIC";
          inherit netbsd-src;
        };
        custom-set = pkgs.callPackage ./custom {
          netbsdRelease = netbsd10.netbsd-release;
        };
        app-set = mkAppsSet {
          inherit arch;
          netbsdRelease = netbsd10.netbsd-release;
          inherit netbsdPkgs;
        };
        embedded-image = mkCustomImage {
          inherit arch;
          mkNetbsdImg = netbsd10.mkNetbsdImg;
          netbsdRelease = netbsd10.netbsd-release;
          appSet = app-set;
          customSet = custom-set.custom-set;
        };
      };

      #########################################################################

      mkAppsSet = { arch, netbsdRelease, netbsdPkgs }: pkgsrc.mkPkgSet {
        pname = "netbsd-set-apps-${arch}";
        version = "10.0_2024Q2";
        setName = "apps";
        netbsdPkgs = with netbsdPkgs; [
          vim
          htop
          screen
          tmux
          file
          wget

          tcpdump
          curl
          lz4
          unrar
          unzip
          bzip2
          tree

          mc
          git
        ];
        inherit netbsdRelease;
      };

      mkCustomImage = { arch, mkNetbsdImg, netbsdRelease, appSet, customSet, }: (pkgs.callPackage ./image {inherit mkNetbsdImg;}).mkEmbeddedImage {
        nameSuffix = arch;
        inherit netbsdRelease;
        pkgSets = [
          appSet
          customSet
        ];
        defaultSets = ["base" "etc" "man" "misc" "modules" "text"];
        diskType = "wd";
        extraSize = 128;
        minWrites = true;
        compress = true;
        serialConsole = false;
      };

      #########################################################################

      netbsd-i386 = mkNetbsdFull {
        arch = "i386";
        machine = "i386";
        netbsdPkgs = pkgsrc.pkgs.i386;
        inherit mkAppsSet;
        inherit mkCustomImage;
      };

      netbsd-amd64 = mkNetbsdFull {
        arch = "amd64";
        machine = "x86_64";
        netbsdPkgs = pkgsrc.pkgs.amd64;
        inherit mkAppsSet;
        inherit mkCustomImage;
      };

    in rec {
      inherit pkgsrc;
      inherit netbsd-i386;
      inherit netbsd-amd64;

      defaultPackage.x86_64-linux = netbsd-i386.embedded-image;
    };
}
