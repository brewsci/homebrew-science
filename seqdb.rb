class Seqdb < Formula
  desc "High-throughput compression of FASTQ data"
  homepage "https://bitbucket.org/mhowison/seqdb"
  url "https://bitbucket.org/mhowison/seqdb/downloads/seqdb-0.2.0.tar.gz"
  sha256 "e7bcf9ebfa584414bc93ebb37e93b1c992b0b379bc541a57c25966bfe9b6f906"
  revision 3

  bottle do
    cellar :any
    sha256 "8ddb581bc22c39c5a58e8e5535b56f11d49a1ef787882fecc367d3d38e101f2a" => :el_capitan
    sha256 "7d9bf9fe088d6473d6f818d91da9a252944c98c46f57b10bebabadb24b6c7f5a" => :yosemite
    sha256 "7368f17d4e48db7d1ef19c366a5c20a073c9a7930c8b5e9a0f782d719c37912f" => :mavericks
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
