class Sailfish < Formula
  desc "Rapid mapping-based RNA-Seq isoform quantification"
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish"
  # doi "10.1038/nbt.2862"
  # tag "bioinformatics"
  url "https://github.com/kingsfordgroup/sailfish/archive/v0.9.1.tar.gz"
  sha256 "c3e74bb95501618ba34883395ac84f07504e038200936b5c03cab269ab60f1de"

  bottle do
    sha256 "1aa9d7ffa390bdb706a23564d39e288fde5adaf2120505553422719ac22cced9" => :el_capitan
    sha256 "3beba76b6e28b9a21a2e0a6f690891111bb3ae88585cac037883c25ef90fea38" => :yosemite
    sha256 "8a9fcdcbd46bf0e6d5d6bf9224f142b1d21712fc1fba32b85e0473d139e5a850" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "tbb"
  needs :cxx11

  def install
    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sailfish", "--version"
  end
end
