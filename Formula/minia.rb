class Minia < Formula
  desc "Short-read assembler of a Bloom filter de Bruijn graph"
  homepage "http://minia.genouest.org/"
  # doi "10.1186/1748-7188-8-22"
  # tag "bioinformatics"

  url "https://github.com/GATB/minia/releases/download/v2.0.7/minia-v2.0.7-Source.tar.gz"
  sha256 "76d96dc14b8c4c01e081da6359c3a8236edafc5ef93b288eaf25f324de65f3ce"

  bottle do
    sha256 "165930add4c386d013532197a6e078c0a56138e578a043cdac95074a7ba9b104" => :el_capitan
    sha256 "a9718a1b14a8cb65fbadb05a8867a50986ad85e776970671c76f16d7f39cfa8d" => :yosemite
    sha256 "0a36cc1620d6fb667b76edd7243cb6954c57422e2629d2132332e56e6667f318" => :mavericks
    sha256 "ed82a1b755f536400457cfed2904bf231288e02d0c6784b7fd72e68fe185bec2" => :x86_64_linux
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
      # Resolve conflict with hdf5: https://github.com/GATB/minia/issues/5
      mv bin/"h5dump", bin/"minia-h5dump"
    end
  end

  test do
    assert_match "options", shell_output("#{bin}/minia")
  end
end
