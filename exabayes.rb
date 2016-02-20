class Exabayes < Formula
  desc "Large-scale Bayesian tree inference"
  homepage "http://sco.h-its.org/exelixis/web/software/exabayes/"
  url "http://sco.h-its.org/exelixis/material/exabayes/1.4.1/exabayes-1.4.1-src.tar.gz"
  sha256 "23e00b361a29365757e760b1acbb9d71744d2be5d9c450f8afdfaf5594d8994f"

  bottle do
    cellar :any
    sha256 "82489020ce980129b4bf9e60f04ae2369e622fc320c3ff79f3db11753e0234d1" => :yosemite
    sha256 "f167fbaff7cf7e468903f4bd2d329c6d457fec135b6ea80c1ce3364f6d32a5ab" => :mavericks
    sha256 "4ab4ed65c609e80b2e28b56703e3432ce280696b214f33ee69f8499683e8015f" => :mountain_lion
  end

  head do
    url "https://github.com/aberer/exabayes.git", :branch => "devel"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
  end

  # Fix: ./src/comm/PendingSwap.hpp:50:8: error: no type named 'unique_ptr' in namespace 'std'
  # ExaBayes needs std::unique_ptr, unordered_map, array
  needs :cxx11

  depends_on :mpi => [:cc, :cxx, :recommended]

  def install
    # Fix: ./src/comm/PendingSwap.hpp:50:8: error: no type named 'unique_ptr' in namespace 'std'
    ENV.libcxx
    args = %W[--disable-dependency-tracking --disable-silent-rules --prefix=#{prefix}]
    args << "--enable-mpi" if build.with? "mpi"
    system "autoreconf", "--install" if build.head?
    system "./configure", *args
    system "make", "install"
    pkgshare.install "examples", "manual"
  end

  def caveats; <<-EOS.undent
    The manual and example files are stored in
      #{opt_prefix}/share/exabayes
    EOS
  end

  test do
    cd testpath do
      (testpath/"config.nex").write <<-EOS.undent
        #nexus
        begin run;
          numgen 10000
          numruns 2
          numcoupledchains 2
          heatfactor 0.01
        end;
      EOS

      (testpath/"aln.phy").write <<-EOS.undent
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

      system *%W[#{bin}/yggdrasil -f aln.phy -m DNA -n test -s 100 -c config.nex -T 2]
      system *%W[#{bin}/sdsf -f ExaBayes_topologies.test.0 ExaBayes_topologies.test.1]
      system *%W[#{bin}/consense -n cons -f ExaBayes_topologies.test.0 ExaBayes_topologies.test.1]
    end
  end
end
