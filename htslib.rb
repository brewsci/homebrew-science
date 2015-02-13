class Htslib < Formula
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/archive/1.2.tar.gz"
  sha1 "de903ec8f92ea86872dbd0dd7f5d419c58366e8b"
  head "https://github.com/samtools/htslib.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "0e80239d79450285119454def8bc5b9bf4eaa50f" => :yosemite
    sha1 "e5ee799c770723753f546a28d7757a6419e292b8" => :mavericks
    sha1 "26310861d0deb4a8669bb499b138024fc5bc7d95" => :mountain_lion
  end

  conflicts_with "tabix", :because => "both htslib and tabix install bin/tabix"

  def install
    # Write version to avoid 0.0.1 version information output from Makefile
    system "echo '#define HTS_VERSION \"#{version}\"' > version.h"
    system "make"
    system "make", "install", "prefix=" + prefix
  end

  test do
    system "#{bin}/bgzip --help 2>&1 |grep bgzip"
    system "#{bin}/tabix --help 2>&1 |grep tabix"
  end
end
