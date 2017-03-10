class Libpll < Formula
  desc "PLL is a C library for doing phylogenetics"
  homepage "http://www.libpll.org/"
  url "http://www.libpll.org/Downloads/libpll-1.0.11.tar.gz"
  sha256 "1fb7af4d09bb935b0cc6c4d0ddff21a29ceff38c401328543d1639299ea31ec1"
  head "https://git.assembla.com/phylogenetic-likelihood-library.git"
  # tag "bioinformatics"
  # doi "10.1093/sysbio/syu084"

  bottle do
    cellar :any
    sha256 "673e8b127b98f71bce9b864f7457ca499d9a205d2fe5c0c1fbb7e29a764634f8" => :sierra
    sha256 "6bb3ef91248dc9c94d4d27eb065d362780200f1fe79a8f6e8e07e020d52c80f3" => :el_capitan
    sha256 "991e9528193e5fabb3911b6262a973ebf448a5625bcdde56b7e736329fe55798" => :yosemite
    sha256 "68006ec1a0965cf49051b6a6d24e9aaef5e96b03c24be6316716aa85039e4e09" => :x86_64_linux
  end

  option "without-test", "Disable build-time checking (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    (testpath/"alignment.phy").write <<-EOS.undent
      10 60
      Cow       ATGGCATATCCCATACAACTAGGATTCCAAGATGCAACATCACCAATCATAGAAGAACTA
      Carp      ATGGCACACCCAACGCAACTAGGTTTCAAGGACGCGGCCATACCCGTTATAGAGGAACTT
      Chicken   ATGGCCAACCACTCCCAACTAGGCTTTCAAGACGCCTCATCCCCCATCATAGAAGAGCTC
      Human     ATGGCACATGCAGCGCAAGTAGGTCTACAAGACGCTACTTCCCCTATCATAGAAGAGCTT
      Loach     ATGGCACATCCCACACAATTAGGATTCCAAGACGCGGCCTCACCCGTAATAGAAGAACTT
      Mouse     ATGGCCTACCCATTCCAACTTGGTCTACAAGACGCCACATCCCCTATTATAGAAGAGCTA
      Rat       ATGGCTTACCCATTTCAACTTGGCTTACAAGACGCTACATCACCTATCATAGAAGAACTT
      Seal      ATGGCATACCCCCTACAAATAGGCCTACAAGATGCAACCTCTCCCATTATAGAGGAGTTA
      Whale     ATGGCATATCCATTCCAACTAGGTTTCCAAGATGCAGCATCACCCATCATAGAAGAGCTC
      Frog      ATGGCACACCCATCACAATTAGGTTTTCAAGACGCAGCCTCTCCAATTATAGAAGAATTA
    EOS

    (testpath/"libpll-test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <stdlib.h>
      #include <pll/pll.h>

      int main (int argc, char * argv[])
      {
          pllInstanceAttr attr;
          attr.rateHetModel = PLL_GAMMA;
          attr.fastScaling  = PLL_FALSE;
          attr.saveMemory   = PLL_FALSE;
          attr.useRecom     = PLL_FALSE;
          attr.randomNumberSeed = 0x12345;

          pllInstance * inst;
          inst = pllCreateInstance (&attr);

          pllAlignmentData * alignmentData;
          alignmentData = pllParseAlignmentFile(PLL_FORMAT_PHYLIP, "alignment.phy");
          if (!alignmentData) {
              printf("Error parsing alignment\\n");
              exit(-1);
          }

          pllQueue * partitionInfo;
          partitionList * partitions;
          partitionInfo = pllPartitionParseString("DNA, P = 1-30\\nDNA, P2 = 31-60");
          if (!pllPartitionsValidate(partitionInfo, alignmentData)) {
              printf("Error parsing partitions\\n");
              exit(-2);
          }
          partitions = pllPartitionsCommit(partitionInfo, alignmentData);
          pllAlignmentRemoveDups(alignmentData, partitions);

          pllTreeInitTopologyRandom(inst, alignmentData->sequenceCount, alignmentData->sequenceLabels);

          pllLoadAlignment(inst, alignmentData, partitions);
          pllInitModel(inst, partitions);

          pllQueuePartitionsDestroy(&partitionInfo);
          pllAlignmentDataDestroy(alignmentData);
          pllPartitionsDestroy(inst, &partitions);
          pllDestroyInstance (inst);
      }
    EOS
    libs = %w[-lpll-sse3 -lm]
    system ENV.cc, "-o", "test", "libpll-test.c",
           "-I#{include}", "-L#{lib}", *libs
    system "./test"
  end
end
