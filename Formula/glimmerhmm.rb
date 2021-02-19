class Glimmerhmm < Formula
  homepage "https://ccb.jhu.edu/software/glimmerhmm/"
  # doi "10.1093/bioinformatics/bth315"
  # tag "bioinformatics"

  url "ftp://ccb.jhu.edu/pub/software/glimmerhmm/GlimmerHMM-3.0.4.tar.gz"
  sha256 "43e321792b9f49a3d78154cbe8ddd1fb747774dccb9e5c62fbcc37c6d0650727"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, high_sierra:  "6c129f46df339601105a9bea74cc34ebd44bfefd70af9602db8728d6efca187b"
    sha256 cellar: :any_skip_relocation, sierra:       "bec2c26c9b1b965de11c91126e799151b14c41854deea4bd3f02e80e1170ceab"
    sha256 cellar: :any_skip_relocation, el_capitan:   "085de0bdee7ea9d218357d4d82fc2eed1963e1c3a7b1930b7f8da48f734d707a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64ad84363d8dbe8c904d886748a84efabc536b3fab72516fb3c18977aba3d559"
  end

  def install
    # fatal error: 'malloc.h' file not found
    inreplace %w[sources/oc1.h sources/util.c train/utils.c], "malloc.h", "stdlib.h"

    system(*%w[make -C sources])
    system(*%w[make -C train])
    bin.install %w[sources/glimmerhmm bin/glimmhmm.pl]
    prefix.install Dir["*"] - %w[bin sources]
  end

  test do
    system "#{bin}/glimmerhmm", "-h"
  end
end
