class Hmmer < Formula
  homepage "http://hmmer.janelia.org"
  # doi "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"
  url "http://selab.janelia.org/software/hmmer3/3.1b1/hmmer-3.1b1.tar.gz"
  sha1 "e05907d28b7f03d4817bb714ff0a8b2ef0210220"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "7bbcead1760d3dbab4125bdead5cf82130a986f6" => :yosemite
    sha1 "d7110164cd86dcfb8c500366fc669354a4ce6b6d" => :mavericks
    sha1 "33da00cd8b9075f4a5437e8ed3f4b47019256623" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  head do
    url "https://svn.janelia.org/eddylab/eddys/src/hmmer/trunk"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"

    share.install "tutorial"
  end

  test do
    system "#{bin}/hmmsearch", "-h"
  end
end
