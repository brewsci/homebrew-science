class Htslib < Formula
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/archive/1.2.1.tar.gz"
  sha1 "904c7e8d1c37d52406a6c3e290d1b03b50acab91"
  head "https://github.com/samtools/htslib.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "7dcc5ba144967b427807c858256753c1077af19c" => :yosemite
    sha1 "526fdef181ed7c54cd68b3384346e78f4c18fb26" => :mavericks
    sha1 "cbb4da3ff94024485eca163d7a42b3c0bfd7c25b" => :mountain_lion
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
