class Beetl < Formula
  desc "Burrows-Wheeler Extended Tool Library"
  homepage "https://github.com/BEETL/BEETL"
  head "https://github.com/BEETL/BEETL.git", :branch => "RELEASE_1_1_0"
  # doi "10.1093/bioinformatics/bts173"
  # tag "bioinformatics"

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
    sha256 "32b190deb3501cb8fe2600860e97edbd78231cc0e400d1236ff09a82e222f5ee" => :el_capitan
    sha256 "f03a3fae57263a692697141f59ae103466b912939734d13d653156bbda59dfc2" => :yosemite
    sha256 "afec472f36aaf5fb71f7d82e92419299be2c54479a2f50a02362407695dbc156" => :mavericks
    sha256 "57c967ead12e01ffe2bd14b9a4b0caa02ad9e80eee5444a7369f26940c449f2c" => :x86_64_linux
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
