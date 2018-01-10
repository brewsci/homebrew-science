class Rnammer < Formula
  desc "Predicts 5s/8s, 16s/18s, and 23s/28s ribosomal RNA in full genome sequences"
  homepage "https://www.cbs.dtu.dk/services/RNAmmer/"
  # doi "10.1093/nar/gkm160"
  # tag "bioinformatics"

  # The tarball may also be downloaded using this web form:
  # https://www.cbs.dtu.dk/cgi-bin/nph-sw_request?rnammer
  url "http://bioinformatics.se/resources_2/rnammer-1.2.src.tar.Z"
  sha256 "c8f0df0c44e3c31b81de5b74de9e6033907976bfdc283ad8c3402af5efc2aae2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b078fa5dc6bf519898c8581e8ea732b50697d89c730129b3468cf2987a583aec" => :yosemite
    sha256 "fef2fe67c4fb223f68c9b570a190e9d354c36d50f8d89d44f4d2dfe10a874b97" => :mavericks
    sha256 "01e971ea063602f93c0b1b139c0da10e4501a4f9b775348d455a7035433a6001" => :mountain_lion
    sha256 "f4af0bc58be8e4ba1d9c75d2eefaf6e04d6501273aee67e8d43445b2061638e8" => :x86_64_linux
  end

  depends_on "hmmer2"

  # Fix "unknown platform"
  patch :DATA

  def install
    share.mkdir
    mv "lib", share/"rnammer"
    man1.install "man/rnammer.1"
    rmdir "man"
    prefix.install Dir["*"]
    bin.install_symlink "../rnammer", "../core-rnammer"
  end

  def caveats; <<-EOS.undent
    For academic users there is no license fee. For the complete license see
      #{opt_prefix}/LICENSE
    There is also a web service at
      https://www.cbs.dtu.dk/services/RNAmmer/
    EOS
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
