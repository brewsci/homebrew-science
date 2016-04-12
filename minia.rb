class Minia < Formula
  desc "Short-read assembler of a Bloom filter de Bruijn graph"
  homepage "http://minia.genouest.org/"
  # doi "10.1186/1748-7188-8-22"
  # tag "bioinformatics"

  url "http://gatb-tools.gforge.inria.fr/versions/src/minia-2.0.3-Source.tar.gz"
  sha256 "494ffec613c3652b5ce941cac7e08a44914fa331750a53f70d17d545372c1997"

  bottle do
    cellar :any
    sha256 "d7ad9d373defc2a515d26b1f583e936b035e724b41f1590171cdcd9e462b2a37" => :yosemite
    sha256 "b774c469fa25cd621b0bf12109c3fee1c93473e4bd3e2ef4686b4fa73bb5e910" => :mavericks
    sha256 "5858e2410ed92dd870e30e2d1ac8f373812ca472a7e3bd5d84ff5a05fd7249aa" => :mountain_lion
  end

  option "with-docs", "Install documentation. Requires LaTeX"

  depends_on "cmake" => :build
  depends_on "imagemagic" => :build if build.with? "docs"

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
