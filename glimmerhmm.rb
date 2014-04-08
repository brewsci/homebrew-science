require "formula"

class Glimmerhmm < Formula
  homepage "http://ccb.jhu.edu/software/glimmerhmm/"
  #doi "10.1093/bioinformatics/bth315"
  url "ftp://ccb.jhu.edu/pub/software/glimmerhmm/GlimmerHMM-3.0.2.tar.gz"
  sha1 "e85b28db2cc2906d7ecc8b93963e6e9163ad4950"

  def install
    # fatal error: 'malloc.h' file not found
    inreplace %w[sources/oc1.h sources/util.c train/utils.c], "malloc.h", "stdlib.h"

    system *%w[make -C sources]
    system *%w[make -C train]
    bin.install %w[sources/glimmerhmm bin/glimmhmm.pl]
    prefix.install Dir["*"] - %w[bin sources]
  end

  test do
    system "#{bin}/glimmerhmm -h"
  end
end
