class Rnammer < Formula
  homepage "http://www.cbs.dtu.dk/services/RNAmmer/"
  # doi "10.1093/nar/gkm160"
  # tag "bioinformatics"

  # The tarball may also be downloaded using this web form:
  # http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?rnammer
  url "http://bioinformatics.se/resources_2/rnammer-1.2.src.tar.Z"
  sha256 "c8f0df0c44e3c31b81de5b74de9e6033907976bfdc283ad8c3402af5efc2aae2"

  depends_on "hmmer2"

  def patches
    # Fix "unknown platform"
    DATA
  end

  def install
    # Fix "FATAL: POSIX threads support is not compiled into HMMER;
    # --cpu doesn't have any effect"
    inreplace "core-rnammer", " --cpu 1", ""

    share.mkdir
    mv "lib", share/"rnammer"
    man1.install "man/rnammer.1"
    rmdir "man"
    prefix.install Dir["*"]
    bin.install_symlink "../rnammer", "../core-rnammer"
  end

  test do
    system "#{bin}/rnammer", "-v"
  end
end

__END__
diff --git a/rnammer b/rnammer
index b3382a9..a51c61d 100755
--- a/rnammer
+++ b/rnammer
@@ -32,10 +32,10 @@ my ($TEMP_WORKING_DIR , $multi,@MOL,%MOL_KEYS,$mol,$kingdom,%FLANK,$gff, $xml ,
 ## PROGRAM CONFIGURATION BEGIN

 # the path of the program
-my $INSTALL_PATH = "/usr/cbs/bio/src/rnammer-1.2";
+my $INSTALL_PATH = "HOMEBREW_PREFIX/opt/rnammer";

 # The library in which HMMs can be found
-my $HMM_LIBRARY = "$INSTALL_PATH/lib";
+my $HMM_LIBRARY = "$INSTALL_PATH/share/rnammer";
 my $XML2GFF = "$INSTALL_PATH/xml2gff";
 my $XML2FSA = "$INSTALL_PATH/xml2fsa";

@@ -46,7 +46,10 @@ my $RNAMMER_CORE     = "$INSTALL_PATH/core-rnammer";
 chomp ( my $uname = `uname`);
 my $HMMSEARCH_BINARY;
 my $PERL;
-if ( $uname eq "Linux" ) {
+if (1) {
+	$HMMSEARCH_BINARY = "HOMEBREW_PREFIX/opt/hmmer2/bin/hmmsearch";
+	$PERL = "perl";
+} elsif ( $uname eq "Linux" ) {
	$HMMSEARCH_BINARY = "/usr/cbs/bio/bin/linux64/hmmsearch";
	$PERL = "/usr/bin/perl";
 } elsif ( $uname eq "IRIX64" ) {
