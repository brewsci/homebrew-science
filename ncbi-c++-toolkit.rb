class NcbiCxxToolkit < Formula
  desc "Collection of libraries for working with biological data."
  homepage "https://www.ncbi.nlm.nih.gov/toolkit/"
  # tag "bioinformatics"

  url "https://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/ARCHIVE/12_0_0/ncbi_cxx--12_0_0.tar.gz"
  sha256 "432d5c72cc02dad263f1b2f1ab875e04e60b1ded0c5537ed54e8095b50554d20"

  head "https://anonsvn.ncbi.nlm.nih.gov/repos/v1/trunk/c++", :using => :svn

  bottle :disable, "Installation is 2.1G so it's too big to bottle"

  fails_with :gcc => "5" do
    cause "5.1.0 is not fully supported."
  end

  # Files that conflict with blast, rmblast and sratoolkit.
  CONFLICTS_BLAST = %w[
    bin/align_format_unit_test
    bin/bdbloader_unit_test
    bin/blast_format_unit_test
    bin/blast_formatter
    bin/blast_services_unit_test
    bin/blast_unit_test
    bin/blastdb_aliastool
    bin/blastdb_format_unit_test
    bin/blastdbcheck
    bin/blastdbcmd
    bin/blastdbcp
    bin/blastinput_unit_test
    bin/blastn
    bin/blastp
    bin/blastx
    bin/convert2blastmask
    bin/datatool
    bin/deltablast
    bin/dustmasker
    bin/gene_info_reader
    bin/gene_info_unit_test
    bin/legacy_blast.pl
    bin/makeblastdb
    bin/makembindex
    bin/makeprofiledb
    bin/project_tree_builder
    bin/psiblast
    bin/rpsblast
    bin/rpstblastn
    bin/seedtop
    bin/segmasker
    bin/seqdb_demo
    bin/seqdb_perf
    bin/seqdb_unit_test
    bin/tblastn
    bin/tblastx
    bin/update_blastdb.pl
    bin/windowmasker
    bin/windowmasker_2.2.22_adapter.py
    bin/writedb_unit_test
  ].freeze
  CONFLICTS_RMBLAST = %w[bin/rmblastn].freeze
  CONFLICTS_SRATOOLKIT = %w[
    bin/abi-dump
    bin/abi-load
    bin/align-info
    bin/bam-load
    bin/cg-load
    bin/fastq-dump
    bin/fastq-load
    bin/helicos-load
    bin/illumina-dump
    bin/illumina-load
    bin/kar
    bin/kdbmeta
    bin/latf-load
    bin/prefetch
    bin/rcexplain
    bin/sff-dump
    bin/sff-load
    bin/sra-pileup
    bin/sra-sort
    bin/sra-stat
    bin/srapath
    bin/srf-load
    bin/test-sra
    bin/vdb-config
    bin/vdb-copy
    bin/vdb-decrypt
    bin/vdb-dump
    bin/vdb-encrypt
    bin/vdb-lock
    bin/vdb-passwd
    bin/vdb-unlock
    bin/vdb-validate
  ].freeze
  CONFLICTS = CONFLICTS_BLAST + CONFLICTS_RMBLAST + CONFLICTS_SRATOOLKIT

  # Fix error: static declaration of 'strndup' follows non-static declaration
  patch :DATA

  def install
    # Fix error with clang. error: 'bits/c++config.h' file not found
    ENV.libstdcxx

    # Fix error: invalid conversion from 'BDB_CompareFunction'
    ENV.append_to_cflags "-fpermissive"

    system "./configure", "--prefix=#{prefix}",
                          "--without-boost",
                          "--without-gnutls"
    system "make"
    system "make", "install"

    # Remove conflicting files.
    cd prefix do
      rm_f CONFLICTS
    end
  end

  test do
    system "#{bin}/agpconvert", "-help"
  end
end

__END__
diff --git a/src/sra/sdk/interfaces/os/mac/os-native.h.orig b/src/sra/sdk/interfaces/os/mac/os-native.h
index b46ef96..8627766 100644
--- a/src/sra/sdk/interfaces/os/mac/os-native.h.orig
+++ b/src/sra/sdk/interfaces/os/mac/os-native.h
@@ -45,6 +45,7 @@ extern "C" {
  */
 char *strdup ( const char *str );

+#if 0
 static __inline__
 char *strndup ( const char *str, size_t n )
 {
@@ -63,6 +64,7 @@ char *strndup ( const char *str, size_t n )

     return dupstr;
 }
+#endif

 /*--------------------------------------------------------------------------
  * strchrnul - implemented inline here
