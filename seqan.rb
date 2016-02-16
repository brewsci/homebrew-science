class Seqan < Formula
  desc "C++ library of sequence algorithms and data structures"
  homepage "http://www.seqan.de/"
  # doi "10.1186/1471-2105-9-11"
  # tag "bioinformatics"

  url "https://github.com/seqan/seqan/releases/download/seqan-v2.1.0/seqan-library-2.1.0.tar.xz"
  mirror "http://packages.seqan.de/seqan-library/seqan-library-2.1.0.tar.xz"
  sha256 "97bbeffcb059d650e4bdf6ffcd3d585910a382525a1a5054941eb080df0c88d2"

  head "https://github.com/seqan/seqan.git"

  # seqan-library installs only header files.
  bottle :unneeded

  def install
    include.install "include/seqan"
    doc.install Dir["share/doc/seqan/*"] unless build.head?
  end

  test do
    # seqan-library installs only header files.
    system "ls", include
  end
end
