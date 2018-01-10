class Exabayes < Formula
  desc "Large-scale Bayesian tree inference"
  homepage "https://sco.h-its.org/exelixis/web/software/exabayes/"
  url "https://github.com/aberer/exabayes/archive/v1.5.tar.gz"
  sha256 "3e5747d2ffb875ea929da666ee8bc8727aa3963bfa86207efe14218fd952c6b3"
  revision 1
  head "https://github.com/aberer/exabayes.git", :branch => "devel"

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on :mpi => [:cc, :cxx, :recommended]

  def install
    args = %W[--disable-dependency-tracking --disable-silent-rules --prefix=#{prefix}]
    args << "--enable-mpi" if build.with? "mpi"
    system "autoreconf", "--install"
    system "./configure", *args
    # Only build the binaries; `make` by itself will also
    # build the manual which requires a full TeX installation.
    progs = %w[yggdrasil parser-exabayes sdsf postProcParam credibleSet extractBips consense exabayes]
    system "make", "date", *progs
    bin.install *progs
    pkgshare.install "examples"
  end

  def caveats; <<-EOS.undent
    The example files are stored in
      #{opt_prefix}/share/exabayes
    EOS
  end

  test do
    (testpath/"config.nex").write <<-EOS.undent
      #nexus
      begin run;
        numgen 10000
        numruns 2
        numcoupledchains 2
        convergencecriterion none
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

    args = build.with?("mpi") ? %W[mpirun -np 2 #{bin}/exabayes] : %W["#{bin}/yggdrasil -T 2]
    args += %W[-f aln.phy -m DNA -n test -s 100 -c config.nex]
    system *args
    system "#{bin}/sdsf", "-f", "ExaBayes_topologies.run-0.test", "ExaBayes_topologies.run-1.test"
    system "#{bin}/consense", "-n", "cons", "-f", "ExaBayes_topologies.run-0.test", "ExaBayes_topologies.run-1.test"
  end
end
