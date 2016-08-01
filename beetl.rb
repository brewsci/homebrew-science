class Beetl < Formula
  desc "Burrows-Wheeler Extended Tool Library"
  homepage "https://github.com/BEETL/BEETL"
  head "https://github.com/BEETL/BEETL.git", :branch => "RELEASE_1_1_0"

  stable do
    url "https://github.com/BEETL/BEETL/archive/BEETL-0.10.0.tar.gz"
    sha256 "161ff8b4b3c99fd313851778c15dc32ab95dcaaf16912402940d53c56a74c283"

    # Fixes "error: 'accumulate' is not a member of 'std'"
    # Upstream commit "Little fix for compilation on mac"
    patch do
      url "https://github.com/BEETL/BEETL/commit/ba47b6f9.patch"
      sha256 "63b67f3282893d1f74c66aa98f3bf2684aaba2fa9ce77858427b519f1f02807d"
    end
  end

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

  def install
    boost = Formula["boost"].opt_prefix
    seqan = Formula["seqan"].opt_prefix/"include"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--with-boost=#{boost}" if build.with? "boost"
    args << "--with-seqan=#{seqan}" if build.with? "seqan"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "beetl", "--version"
  end
end
