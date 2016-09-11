class Seqdb < Formula
  desc "High-throughput compression of FASTQ data"
  homepage "https://bitbucket.org/mhowison/seqdb"
  url "https://bitbucket.org/mhowison/seqdb/downloads/seqdb-0.2.0.tar.gz"
  sha256 "e7bcf9ebfa584414bc93ebb37e93b1c992b0b379bc541a57c25966bfe9b6f906"
  revision 3

  bottle do
    cellar :any
    sha256 "f67b91b4ac4cc9b7c37bb25f4a0f4cb41017502e693b1d9109af4dcab6b95a16" => :el_capitan
    sha256 "8f4b25df86a0977e5c9898d737e527a4a946d38f93da7a9fa1af9bff038d5a80" => :yosemite
    sha256 "80ecdb90b18ffcb3d31e99df7833f5e00858a2fbc4dc9283f6e0e29f398e6bfa" => :mavericks
  end

  needs :openmp

  depends_on "hdf5"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "seqdb"
  end
end
