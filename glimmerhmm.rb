class Glimmerhmm < Formula
  homepage "http://ccb.jhu.edu/software/glimmerhmm/"
  #doi "10.1093/bioinformatics/bth315"
  #tag "bioinformatics"

  url "ftp://ccb.jhu.edu/pub/software/glimmerhmm/GlimmerHMM-3.0.2.tar.gz"
  sha1 "e85b28db2cc2906d7ecc8b93963e6e9163ad4950"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3a0c44274577c5c287c86ee14da88947efdf9950" => :yosemite
    sha1 "dae57d85c6a4b06f603d711ce2bc403191d7a542" => :mavericks
    sha1 "4aa039c9b8fdd654dcfad45f2db9a3e96a5c33b1" => :mountain_lion
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
