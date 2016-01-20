class Beetl < Formula
  desc "Burrows-Wheeler Extended Tool Library"
  homepage "https://github.com/BEETL/BEETL"
  url "https://github.com/BEETL/BEETL/archive/BEETL-0.9.0.tar.gz"
  sha256 "d310ee76809fd99fe4a1e82a65a90ebbbdbca005f1e763bc9119929a6f06b290"

  bottle do
    cellar :any
    sha256 "80c5e95fbdb851bd1d5f7b31361c1552eb690feae4131fd422f5482b2145ec57" => :el_capitan
    sha256 "0068755c3faa9344cbf71e0df4c88674a7260dc18e459d8dcf5e04503ff17201" => :yosemite
    sha256 "a220aff6131e9b0d70a75d365671107cbc167b28892458fb60d0d1700064d0ee" => :mavericks
  end

  depends_on "boost" => :optional
  depends_on "seqan" => :optional

  needs :cxx11
  needs :openmp

  patch do
    # Include necessary headers
    url "https://github.com/sjackman/BEETL/commit/c91ad73.diff"
    sha256 "2b99dddb7c5becaede8e3cb4b71e73178b51d8653089a523af682063f012774d"
  end

  def install
    boost = Formula["boost"].opt_prefix
    seqan = Formula["seqan"].opt_prefix/"include"
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"]
    args << "--with-boost=#{boost}" if build.with? "boost"
    args << "--with-seqan=#{seqan}" if build.with? "seqan"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "beetl --version"
  end
end
