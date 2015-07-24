class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.14.tar.gz"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"
  sha256 "2411c4f56f477b42dff54db2b7ffc0b7cf53bb9778d54982595c64cc69c40fc1"
  revision 1

  bottle do
    revision 1
    sha256 "c49c869f45c87cc375c573a160dd7ee219f2c9d16ef2acdbd9d385cc0561bf5a" => :yosemite
    sha256 "668ccea63190d3a0f0cca606bc92424200076cc488c1f398149a74340dd4b82a" => :mavericks
    sha256 "a6a592b7b7378665b606e414658847c5260eeebbc6c5ae32ba699a79e7547c3d" => :mountain_lion
  end

  depends_on :fortran

  # OS X provides the Accelerate.framework, which is a BLAS/LAPACK impl.
  keg_only :provided_by_osx

  def install
    ENV["DYNAMIC_ARCH"] = "1" if build.bottle?

    # Must call in two steps
    system "make", "FC=#{ENV['FC']}", "libs", "netlib", "shared"
    system "make", "FC=#{ENV['FC']}", "tests"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
