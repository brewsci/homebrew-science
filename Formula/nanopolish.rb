class Nanopolish < Formula
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  url "https://github.com/jts/nanopolish.git",
        :tag => "v0.7.2",
        :revision => "55b6768062ac283d0109f63aeab7f63203796505"
  head "https://github.com/jts/nanopolish.git"

  # doi "10.1038/nmeth.3444"
  # tag "bioinformatics"

  bottle do
    sha256 "9c88b5dc830fb9c1f50dd02d85fcd862c5a00de59b22265af8e6c91d768f986f" => :sierra
    sha256 "0fd1e70ac85708a8a7d76d1b694ddb2337f48b2bbb81bad57b9e67870e405fe5" => :el_capitan
    sha256 "95b2d97edcc11b0c64960888a7751d2ec105af235b35c5af69e6a5cb13c30f96" => :x86_64_linux
  end

  needs :cxx11
  needs :openmp

  depends_on "hdf5"
  depends_on "eigen" => :build

  # Fails to build under yosemite
  depends_on MinimumMacOSRequirement => :el_capitan

  def install
    # Ensure we use brewed 'hdf5' and 'eigen3'
    # Awaiting patch to allow use of brewed 'htslib' https://github.com/jts/nanopolish/issues/213
    system "make", "HDF5=", "EIGEN=", "EIGEN_INCLUDE=-I#{Formula["eigen"].opt_include}/eigen3"
    prefix.install "scripts", "nanopolish"
    bin.install_symlink "../nanopolish"
    pkgshare.install "test"
  end

  test do
    exe = "#{bin}/nanopolish"
    assert_match "valid commands", shell_output("#{exe} --help")
    assert_match version.to_s, shell_output("#{exe} --version")
    assert_match ">channel_8_read_24", shell_output("#{exe} extract #{pkgshare}/test/data/LomanLabz_PC_Ecoli_K12_R7.3_2549_1_ch8_file30_strand.fast5")
  end
end
