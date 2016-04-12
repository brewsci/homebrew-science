class Minia < Formula
  desc "Short-read assembler of a Bloom filter de Bruijn graph"
  homepage "http://minia.genouest.org/"
  # doi "10.1186/1748-7188-8-22"
  # tag "bioinformatics"

  url "http://gatb-tools.gforge.inria.fr/versions/src/minia-2.0.3-Source.tar.gz"
  sha256 "494ffec613c3652b5ce941cac7e08a44914fa331750a53f70d17d545372c1997"

  bottle do
    sha256 "434cf1e9e71f20651bb324403754d6618648b9e707cb29250322f19ac550118b" => :el_capitan
    sha256 "c652ff072aba5cb9cfae040183bc1ecaeaf60ac872be3b73a16caa8fc9b9176e" => :yosemite
    sha256 "a2ec64fb3fc86c5fb1c76c46d79e37e85e96bcd5c3795cd772fe799693b9cc88" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "imagemagick" => :build if build.with? "tex"
  depends_on :tex => [:build, :optional]

  def install
    mkdir "build" do
      args = std_cmake_args
      # Fix error: 'hdf5/hdf5.h' file not found
      args.delete "-DCMAKE_BUILD_TYPE=Release"
      args << "-DSKIP_DOC=1" if build.without? "docs"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "options", shell_output("#{bin}/minia")
  end
end
