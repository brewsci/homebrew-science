class Velvetoptimiser < Formula
  homepage "http://bioinformatics.net.au/software.velvetoptimiser.shtml"
  url "http://www.vicbioinformatics.com/VelvetOptimiser-2.2.5.tar.gz"
  sha256 "a7c2f213dff80f8448081a15a487a55cb5e3432f836763bcb5c38abc800af503"
  head "https://github.com/Victorian-Bioinformatics-Consortium/VelvetOptimiser.git"

  depends_on "velvet"
  depends_on "Bio::Perl" => :perl

  def install
    bin.install "VelvetOptimiser.pl"
    (lib / "perl").install "VelvetOpt"
  end

  # Fix shebang to use the perl found in PATH.
  # Remove GNU-specific flag --preserve-root passed to 'rm'.
  patch :DATA

  test do
    system "VelvetOptimiser.pl --version"
  end
end

__END__
--- VelvetOptimiser-2.2.5/VelvetOptimiser.pl	2012-10-22 22:18:23.000000000 -0400
+++ VelvetOptimiser-2.2.5/VelvetOptimiser.pl.fixed	2013-04-09 12:42:19.000000000 -0400
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 #
 #       VelvetOptimiser.pl
 #
@@ -31,7 +31,7 @@
 #
 use POSIX qw(strftime);
 use FindBin;
-use lib "$FindBin::Bin";
+use lib "$FindBin::RealBin/../lib/perl";
 use threads;
 use threads::shared;
 use VelvetOpt::Assembly;
@@ -386,7 +386,7 @@
 foreach my $key(keys %assemblies){
 	unless($key == $bestId){ 
 		my $dir = $assembliesObjs{$key}->{ass_dir};
-		system('rm', '-r', '--preserve-root', $dir);
+		system('rm', '-r', $dir);
 	} 
 }
 unless ($finaldir eq "."){
