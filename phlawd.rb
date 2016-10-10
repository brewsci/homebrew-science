class Phlawd < Formula
  desc "Phylogenetic dataset construction"
  homepage "http://www.phlawd.net/"
  # The most up to date version of phlawd is the chinchliff fork, which contains
  # a variety of bug fixes and new features. This fork and the (original)
  # blackrim fork will eventually be merged.
  url "https://github.com/chinchliff/phlawd/releases/download/3.4a/phlawd_3.4a_src_with_sqlitewrapped_1.3.1.tar.gz"
  version "3.4a"
  sha256 "0ec8e45359af6e932ea4a042fe4f42ddf05b04689a25df937b2d85db41038253"
  revision 2
  head "https://github.com/chinchliff/phlawd.git"
  # doi "10.1186/1471-2148-9-37"
  # tag "bioinformatics"

  bottle do
    cellar :any
    rebuild 1
    sha256 "eab194f5f8a40fffc3801a179d8b794c28ff29232cd2a666a05fe34913c2cdbe" => :sierra
    sha256 "98172e8ee0bce6476d8c39e8bda5bfe6bc9ac582a41c5be2507d3f8a527bc5c4" => :el_capitan
    sha256 "147f7deae6e1c6c0f3697ed7f3c893b338bc147fb0fc2a4f28054806982b5fef" => :yosemite
    sha256 "c51b6f732f0acb671eecdf4604fb4603fa4e5f40dad96e77d6e0f47b5475d872" => :x86_64_linux
  end

  fails_with :llvm do
    cause "The llvm compiler is not supported."
  end

  # correct the makefile to look for dependencies where brew installs them
  patch :DATA

  needs :openmp

  depends_on "wget"
  depends_on "mafft"
  depends_on "muscle"
  depends_on "quicktree"
  depends_on "sqlite"

  def install
    # Linux doesn't support -arch
    if OS.linux?
      inreplace "sqlitewrapped-1.3.1/Makefile", "-arch x86_64", ""
      inreplace "src/Makefile.MAC", "-arch x86_64", ""
    end
    # compile sqlitewrapped: a dependency included here since it's uncommon and unmaintained
    system "make", "-C", "sqlitewrapped-1.3.1"

    # compile and install phlawd
    system "make", "-C", "src", "-f", "Makefile.MAC"
    bin.install "src/PHLAWD"
  end

  test do
    # currently developing better tests for the next release
    assert_match version.to_s, shell_output("#{bin}/PHLAWD")
  end
end

__END__
diff --git a/src/Makefile.MAC b/src/Makefile.MAC
index a48def0..4b683dd 100644
--- a/src/Makefile.MAC
+++ b/src/Makefile.MAC
@@ -91,8 +91,7 @@ all: PHLAWD
 # Tool invocations
 PHLAWD: $(OBJS) $(USER_OBJS)
 	@echo 'Building target: $@'
-#	$(CC) $(CFLAGS) -L../deps/mac -L/usr/local/lib -L/usr/lib -o "PHLAWD" $(OBJS) $(USER_OBJS) $(LIBS)
-	$(CC) $(CFLAGS) -L../deps/mac -L/usr/local/lib -o "PHLAWD" $(OBJS) $(USER_OBJS) $(LIBS)
+	$(CC) $(CFLAGS) -L$HOMEBREW_PREFIX/lib -I$HOMEBREW_PREFIX/include -L../sqlitewrapped-1.3.1 -I../sqlitewrapped-1.3.1 -o "PHLAWD" $(OBJS) $(USER_OBJS) $(LIBS)
 	@echo 'Finished building target: $@'
 	@echo ' '
 
