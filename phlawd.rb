class Phlawd < Formula
  desc "Phylogenetic dataset construction"
  homepage "http://www.phlawd.net/"
  # doi "10.1186/1471-2148-9-37"

  # the most up to date version of phlawd is the chinchliff fork, which contains a variety of bug fixes and new features.
  # this fork and the (original) blackrim fork will eventually be merged.
  version "3.4a"
  url "https://github.com/chinchliff/phlawd/releases/download/#{version}/phlawd_#{version}_src_with_sqlitewrapped_1.3.1.tar.gz"
  sha256 "0ec8e45359af6e932ea4a042fe4f42ddf05b04689a25df937b2d85db41038253"
  head "https://github.com/chinchliff/phlawd.git"

  bottle do
    cellar :any
    sha256 "66384861ece2d0bd3b185e0a9e61c6ddf4804ee2f207ee4ea855db46404b4595" => :yosemite
    sha256 "cd18cc314338e58c40b60056a52ab6ba0c454a96e24f492e396f1115813a8d9d" => :mavericks
    sha256 "e9838c36ef3081f5c27a105574d6d9bb9f1a6a3275c6ebb7fd148b305af89129" => :mountain_lion
  end

  fails_with :clang do
    build 600
    cause <<-eos
      PHLAWD requires openmp support, which is not available in clang.
      Currently, PHLAWD can only be compiled with gcc > 4.2.
    eos
  end

  fails_with :llvm do
    cause "The llvm compiler is not supported."
  end

  # correct the makefile to look for dependencies where brew installs them
  patch :DATA

  needs :openmp

  depends_on "mafft"
  depends_on "muscle"
  depends_on "quicktree"
  depends_on "sqlite"

  def install
    # compile sqlitewrapped: a dependency included here since it uncommon and unmaintained
    system "make", "-C", "sqlitewrapped-1.3.1"

    # compile and install phlawd
    system "make", "-C", "src", "-f", "Makefile.MAC"
    prefix.install "src/PHLAWD"
    bin.install_symlink "../PHLAWD"
  end

  test do
    # currently developing tests, they will be included in next release
    system "#{bin}/PHLAWD"
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
 
