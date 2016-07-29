class Seqan < Formula
  desc "C++ library of sequence algorithms and data structures"
  homepage "http://www.seqan.de/"
  # doi "10.1186/1471-2105-9-11"
  # tag "bioinformatics"

  url "https://github.com/seqan/seqan/releases/download/seqan-v2.2.0/seqan-library-2.2.0.tar.xz"
  mirror "http://packages.seqan.de/seqan-library/seqan-library-2.2.0.tar.xz"
  sha256 "b5c036a3d2fc2fe5f2d57dcd4d7c523a6df146ab7b44bc789f42004b058d72fd"
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
      pkgshare.install "share/cmake"
      lib.install "share/pkgconfig"
    end
  end

  test do
    # seqan-library installs only header files.
    system "ls", include
  end
end
