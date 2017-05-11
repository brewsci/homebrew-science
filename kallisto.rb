class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # doi "10.1038/nbt.3519"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.43.1.tar.gz"
  sha256 "7baef1b3b67bcf81dc7c604db2ef30f5520b48d532bf28ec26331cb60ce69400"
  revision 1

  bottle do
    cellar :any
    sha256 "7035420d62e7b33e3d4fe5fe56c1da956c0a1a113853a41d36e2bd515132c173" => :sierra
    sha256 "21e9553ef64e7fe8a705fd74d217eec59a08f8b80e81de723c72c09a6764a0e2" => :el_capitan
    sha256 "618ed14f334c6953c92929ab28db334a5c6c25e9d768542c70df6ad970149993" => :yosemite
    sha256 "3fd527afb4c56493f6ab07b910916c074407e89c23244729bdb84564cfa0e1ae" => :x86_64_linux
  end

  needs :cxx11
  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kallisto", 1)
  end
end
