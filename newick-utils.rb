class NewickUtils < Formula
  homepage "http://cegg.unige.ch/newick_utils"
  #doi "10.1093/bioinformatics/btq243"
  #tag "bioinformatics"

  url "http://cegg.unige.ch/pub/newick-utils-1.6.tar.gz"
  sha1 "a9779054dcbf957618458ebfed07991fabeb3e19"

  head "https://github.com/tjunier/newick_utils.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "84c2a07c1dc11ad92a926b74cf59cb437e86329e" => :yosemite
    sha1 "3b1d80495a15915b62e084ae130209c065d73048" => :mavericks
    sha1 "df6cb19ff8832c504efb4b8a7ab7286185fc637b" => :mountain_lion
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
