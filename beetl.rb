class Beetl < Formula
  desc "Burrows-Wheeler Extended Tool Library"
  homepage "https://github.com/BEETL/BEETL"
  url "https://github.com/BEETL/BEETL/archive/BEETL-0.9.0.tar.gz"
  sha256 "d310ee76809fd99fe4a1e82a65a90ebbbdbca005f1e763bc9119929a6f06b290"

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
