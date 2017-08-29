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
    cellar :any
    sha256 "a60b68202e26a304b4dbfdd671b64c3cad4ed9a683889587d3ddecf9a822eaf6" => :sierra
    sha256 "258c71146960a9c55a131f8e216b13c7d6240b6d84b2dc7c1b738d489df73b9e" => :el_capitan
    sha256 "27ebe3f9dce4ce67ab612f38c070db01d51b2e759338ab0a82e7a23d665ff4b1" => :x86_64_linux
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
