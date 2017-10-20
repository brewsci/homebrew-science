class Seqan < Formula
  desc "C++ library of sequence algorithms and data structures"
  homepage "https://www.seqan.de/"
  # doi "10.1186/1471-2105-9-11"
  # tag "bioinformatics"

  url "https://github.com/seqan/seqan/releases/download/seqan-v2.3.2/seqan-library-2.3.2.tar.xz"
  sha256 "c4dc0657a9e125f27512798b709f1589f7d9a6d67ff9bbbe9aec0cff44d83d01"
  head "https://github.com/seqan/seqan.git"

  # seqan-library installs only header files.
  bottle :unneeded

  def install
    include.install "include/seqan"
    if build.head?
      prefix.install_metafiles
      pkgshare.install Dir["*"]
    else
      prefix.install_metafiles "share/doc/seqan"
      doc.install Dir["share/doc/seqan/*"]
      mv "lib", prefix
    end
  end

  test do
    # seqan-library installs only header files.
    system "ls", include
  end
end
