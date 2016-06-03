class Glimmerhmm < Formula
  homepage "http://ccb.jhu.edu/software/glimmerhmm/"
  # doi "10.1093/bioinformatics/bth315"
  # tag "bioinformatics"

  url "ftp://ccb.jhu.edu/pub/software/glimmerhmm/GlimmerHMM-3.0.2.tar.gz"
  sha256 "7a9c442dc0cbdb001ed55fc29e1f1283502bdff4db596803ffcac8965d66f7dc"

  bottle do
    cellar :any
    sha256 "da6d1cb5474a93aec63ee57744ec3c6b036d8cdc762fb2d7a413c155910e7354" => :yosemite
    sha256 "29e2af8728db02b766e7e1b71cd37d5b360b308ece7f58bb5de34b408c7ddb29" => :mavericks
    sha256 "701387377b202acb5407c238db3cf8c0261cafac7ae441da486d36903cf1b22d" => :mountain_lion
    sha256 "96f5e9f71fe3af2c5cff493b6f90ea9e233ae345d5f3a4897acfcf8fa9fd498d" => :x86_64_linux
  end

  def install
    # fatal error: 'malloc.h' file not found
    inreplace %w[sources/oc1.h sources/util.c train/utils.c], "malloc.h", "stdlib.h"

    system *%w[make -C sources]
    system *%w[make -C train]
    bin.install %w[sources/glimmerhmm bin/glimmhmm.pl]
    prefix.install Dir["*"] - %w[bin sources]
  end

  test do
    system "#{bin}/glimmerhmm", "-h"
  end
end
