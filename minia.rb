class Minia < Formula
  desc "Short-read assembler of a Bloom filter de Bruijn graph"
  homepage "http://minia.genouest.org/"
  # doi "10.1186/1748-7188-8-22"
  # tag "bioinformatics"

  url "https://github.com/GATB/minia/releases/download/v2.0.7/minia-v2.0.7-Source.tar.gz"
  sha256 "76d96dc14b8c4c01e081da6359c3a8236edafc5ef93b288eaf25f324de65f3ce"

  bottle do
    sha256 "434cf1e9e71f20651bb324403754d6618648b9e707cb29250322f19ac550118b" => :el_capitan
    sha256 "c652ff072aba5cb9cfae040183bc1ecaeaf60ac872be3b73a16caa8fc9b9176e" => :yosemite
    sha256 "a2ec64fb3fc86c5fb1c76c46d79e37e85e96bcd5c3795cd772fe799693b9cc88" => :mavericks
    sha256 "989049eb72e29cba6eceb0179273236d649738bae40251aaeaf35a6f74c8a90c" => :x86_64_linux
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
