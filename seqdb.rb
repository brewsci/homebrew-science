class Seqdb < Formula
  desc "High-throughput compression of FASTQ data"
  homepage "https://bitbucket.org/mhowison/seqdb"
  url "https://bitbucket.org/mhowison/seqdb/downloads/seqdb-0.2.0.tar.gz"
  sha256 "e7bcf9ebfa584414bc93ebb37e93b1c992b0b379bc541a57c25966bfe9b6f906"
  revision 4

  bottle do
    cellar :any
    sha256 "3fd434ab0761d5510d6dd9b7f8cc306e05aad2f64fcd7bf7fd44add7a33f42e7" => :sierra
    sha256 "700eaf5a407cb37307a94332e8efdaf74f045360b10007e44f4e4435f767a7f7" => :el_capitan
    sha256 "9a9ff3e6fa1266609cfacd0e2108202fc3284bcf58763efdae5eb4661eb71909" => :yosemite
    sha256 "0bc7d8e9655c6230563f7e55660e5e84ec40983a82713cb264a6c71a011efff0" => :x86_64_linux
  end

  needs :openmp

  depends_on "hdf5"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/seqdb"
  end
end
