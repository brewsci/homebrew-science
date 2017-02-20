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
    sha256 "6d4886d7286af7ba1c7f4615bd1aab9af0a87a72d72767d8659b836649059a10" => :yosemite
    sha256 "0f9f835ab42cace506d68c8e90e47d5a558a0387297672592a1736057666c6bd" => :mavericks
    sha256 "7b0a93079fdbb1f063c940cb054dbba66267c06e6238fa40b5d96bbe67d77201" => :mountain_lion
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
