{ lib
, mkPkgsrcPackage 
}:
{
  amd64 = {
    vim = mkPkgsrcPackage {
      pname = "vim";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-rucRDZsQgSMEPoUlZbjwVWXGDQpLSjYnWrl5c75pxrs=";
    };
    htop = mkPkgsrcPackage {
      pname = "htop";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-NKDyTdwHk5nEc/PrfNgS2/B0FAhC/d2PTbAnP1a0sxk=";
    };
    tmux = mkPkgsrcPackage {
      pname = "tmux";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-He17tJ9TpqyfeWAbtTVluXATENruKQq5nr8Cw19rkts=";
    };
    wget = mkPkgsrcPackage {
      pname = "wget";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-9HIFN57lfqz682Mv++3bOyualVDxh9JoMXo4MJKiTn4=";
    };
    curl = mkPkgsrcPackage {
      pname = "curl";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-T2P8owXDLXwN1hR0U7CNxPTwBOCi2ZCAXmTKuKPFzDs=";
    };
    screen = mkPkgsrcPackage {
      pname = "screen";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-iVAHdoAc5n6jxDHLEltgF+NVAJrXKf1Pi4kJP90ie/o=";
    };
    file = mkPkgsrcPackage {
      pname = "file";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-stTP/qFDGLjYuw7PmSYMVaW/CXh1jzSG5s/DTnf1AmE=";
    };
    tcpdump = mkPkgsrcPackage {
      pname = "tcpdump";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-SACbJAdXvWkCNL+gmhlbh3uXNq7D/3np4jfA9H6Cy4I=";
    };
    lz4 = mkPkgsrcPackage {
      pname = "lz4";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-sijFjeITVCSoK9xHXcS2A/9s4enjP4QJpxvZty0CWHE=";
    };
    unrar = mkPkgsrcPackage {
      pname = "unrar";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-nx8h/6bCLyHmPQ179FVkp5X8OnHno01cUqaQWddP07w=";
    };
    unzip = mkPkgsrcPackage {
      pname = "unzip";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-+jOx3lGho8ZePu5w99rmNOJ+5Vl3ToV1HJT6aYCmArQ=";
    };
    bzip2 = mkPkgsrcPackage {
      pname = "bzip2";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-BDHfYmM9C19w1jbi+ReWav7hgx4TtbHv50seFtJedOs=";
    };
    mc = mkPkgsrcPackage {
      pname = "mc";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-rH5ZhtrYecWfvpt0a4n/kQje++6CoRYEmioSnlT0T5I=";
    };
    tree = mkPkgsrcPackage {
      pname = "tree";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-sI5LrgHPE5460GbsgTb4W0L9i41PdxA9ofFiQo0yTr0=";
    };
    git = mkPkgsrcPackage {
      pname = "git-base";
      version = "1.0";
      arch = "amd64";
      outputHash = "sha256-7aq2MXeitGdFCkwTvj4BL4ULm7Zg9SZ5LGDYWfpzpuc=";
    };
  };
  i386 = {
    vim = mkPkgsrcPackage {
      pname = "vim";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-X2nuwkWGxESPpUVewTj6wK5e0yFUpn5JR1n4FZSxwrg=";
    };
    htop = mkPkgsrcPackage {
      pname = "htop";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-L0vOhtzTaQ+Hw7Mv0QDoWqcfZTLloZdOt06XKpFifs8=";
    };
    tmux = mkPkgsrcPackage {
      pname = "tmux";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-EMJhArITarOT+sREO/+0psowTTqyL7HhC2Vf0xJ3WgU=";
    };
    wget = mkPkgsrcPackage {
      pname = "wget";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-V/xpJ31OGIgQKkiHblq/xDsfIHvVqP5lvR8crV4nB8I=";
    };
    curl = mkPkgsrcPackage {
      pname = "curl";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-HGLGmjX8cDIGFKyjUx+L3Mhr7oEcRshJQiLoFhUCVSQ=";
    };
    screen = mkPkgsrcPackage {
      pname = "screen";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-2pFD3uC3RduMsTyKQMSRzoHTGs/W8TLQ3bsC7i4MoxU=";
    };
    file = mkPkgsrcPackage {
      pname = "file";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-cfguMsP/GouKSGg6Rby9HO70/UhPiJ1bj2m6EDDI7j0=";
    };
    tcpdump = mkPkgsrcPackage {
      pname = "tcpdump";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-yIrtQ0o2IU7L6MlhHrx8QjPw3V7lX2dXGC9d062x/sQ=";
    };
    lz4 = mkPkgsrcPackage {
      pname = "lz4";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-sznnGvyyQmZtDeUqLb/UrNl0Hy3VVfkvXoDGnVq6iYs=";
    };
    unrar = mkPkgsrcPackage {
      pname = "unrar";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-2UYLYGUQ3GuLrk02PJTpCsK64PRCKDezm3Ex1VfSw9E=";
    };
    unzip = mkPkgsrcPackage {
      pname = "unzip";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-uiYUTnugeaUmccZjrGvYiGniL/UlyJgKM2P0xB6BAxw=";
    };
    bzip2 = mkPkgsrcPackage {
      pname = "bzip2";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-Sc4IXw1r4IyYroMdVXCOHO6SDt6DABi0qaOE6TQsnHA=";
    };
    mc = mkPkgsrcPackage {
      pname = "mc";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-0nTqI24hiVqXZdA3GqGDjcKvKv3AX7KanBsoPAViivc=";
    };
    tree = mkPkgsrcPackage {
      pname = "tree";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-HkD50ZEwc7d2oFUyaDYGNZ/giXY2uDIKwTdjJISJjCM=";
    };
    git = mkPkgsrcPackage {
      pname = "git-base";
      version = "1.0";
      arch = "i386";
      outputHash = "sha256-UGQyIJ9v0zd7DtPXIhWO3I1EXKba5VULZ0HkOgktEM8=";
    };
  };
}
