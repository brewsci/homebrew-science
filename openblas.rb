class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.14.tar.gz"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"
  sha256 "2411c4f56f477b42dff54db2b7ffc0b7cf53bb9778d54982595c64cc69c40fc1"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "bb37139a9c32a083edb7e55293383b0c6816427497db5e55e66df43aa4a9628c" => :yosemite
    sha256 "ff0f0a3775ab498c326b412be6b9743ab5d00453d6b7c23669a194f9f66b9358" => :mountain_lion
  end

  depends_on :fortran

  # OS X provides the Accelerate.framework, which is a BLAS/LAPACK impl.
  keg_only :provided_by_osx

  def install
    ENV["TARGET"] = "CORE2" if build.bottle?

    # Must call in two steps
    system "make", "FC=#{ENV['FC']}", "libs", "netlib", "shared"
    system "make", "FC=#{ENV['FC']}", "tests"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    if !installed? || Tab.for_formula(self).bottle?
      command = installed? ? "reinstall" : "install"
      <<-EOS.undent
        Prebuilt openblas bottles are not optimized for your microarchitecture,
        so an openblas built from source may be faster than a bottle.
        To get the best openblas performance, #{command} openblas with
          brew #{command} openblas --build-from-source
      EOS
    end
  end
end
