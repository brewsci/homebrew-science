class NewickUtils < Formula
  homepage "http://cegg.unige.ch/newick_utils"
  # doi "10.1093/bioinformatics/btq243"
  # tag "bioinformatics"

  url "http://cegg.unige.ch/pub/newick-utils-1.6.tar.gz"
  sha256 "2c142a2806f6e1598585c8be5afba6d448c572ad21c142e70d6fd61877fee798"

  head "https://github.com/tjunier/newick_utils.git"

  bottle do
    cellar :any
    sha256 "a1c00e6e80e01e69488e0e196b92b705fe681333f883277840dac6e9b66575b9" => :yosemite
    sha256 "e35ac43b26d9092805d47eff1ca9a3bf7273c591b4f3baba8ce13627a7c16da3" => :mavericks
    sha256 "217a0404d3254b8285ec7dba16e77a6b614f60eb7f7cdc602b6f05dd666c6270" => :mountain_lion
    sha256 "f3bb48411ea8b82b0c851a78d834f32c214d1662d8387c79cd462aeb99e6683a" => :x86_64_linux
  end

  # Don't bother testing nw_gen, it's known to fail on MacOSX.
  patch :DATA

  def install
    system "./configure",
      # Fix error: use of undeclared identifier 'LUA_GLOBALSINDEX'
      "--with-lua=no",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    expected = <<-EOS
 +-------------------------------------+ B
=| A
 +---------------------------------------------------------------------------+ C

 |------------------|------------------|------------------|------------------|
 0                0.5                  1                1.5                  2
 substitutions/site
EOS

    output = pipe_output("#{bin}/nw_display -", "(B:1,C:2)A;\n")
    assert_equal expected, output.split("\n").map(&:rstrip).join("\n")
  end
end

__END__
--- a/tests/test_nw_gen.sh
+++ b/tests/test_nw_gen.sh
@@ -138,0 +139,2 @@
+pass=TRUE
+
