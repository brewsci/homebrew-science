class Geneid < Formula
  homepage "http://genome.crg.es/software/geneid/"
  url "ftp://genome.crg.es/pub/software/geneid/geneid_v1.4.4.Jan_13_2011.tar.gz"
  sha1 "9cbed32d0bfb530252f97b83807da2284967379b"
  version "1.4.4"

  bottle do
    cellar :any
    sha1 "8f4611d292aa4ea16438c82e7959afee0ef010d4" => :yosemite
    sha1 "337b80bafc8cdb354eb75ecb0e61bf73e82b991b" => :mavericks
    sha1 "86baedd3f360621baa3ca71cdb62f6859f45f0f9" => :mountain_lion
  end

  def install
    system "make"
    bin.install Dir["bin/*"]
    doc.install "README", *Dir["docs/*"]
    pkgshare.install Dir["param/*.param"]
  end

  def caveats; <<-EOS.undent
    The parameter files are installed in
      #{HOMEBREW_PREFIX}/share/geneid
    EOS
  end

  test do
    system "geneid", "-h"
  end
end
