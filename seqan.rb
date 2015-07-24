class Seqan < Formula
  homepage "http://www.seqan.de/"
  # doi "10.1186/1471-2105-9-11"
  # tag "bioinformatics"

  url "http://packages.seqan.de/seqan-library/seqan-library-1.4.2.tar.bz2"
  sha1 "2413d558c2665ae813bb0a2ab3aa57e07cc00675"

  bottle do
    cellar :any
    sha1 "26f7482ddf437875f0254d75887e0a088c545c4f" => :yosemite
    sha1 "bfcd857c0b28f56770ea87b9cbada300c944787c" => :mavericks
    sha1 "d2df35b6b75cac64ab4b9fcb772a477d16c52c75" => :mountain_lion
  end

  devel do
    url "http://packages.seqan.de/seqan-library/seqan-library-2.0.0.tar.bz2"
    sha1 "872335665632ca63d115ac3042b4f1d28ab0d872"
  end

  head "http://svn.seqan.de/seqan/trunk/core"

  def install
    include.install "include/seqan"
    doc.install Dir["share/doc/seqan/*"] unless build.head?
  end
end
