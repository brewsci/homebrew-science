class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.14.tar.gz"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"
  sha256 "2411c4f56f477b42dff54db2b7ffc0b7cf53bb9778d54982595c64cc69c40fc1"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha256 "fcb647e46fdbfab51d161a0bdb95fcc2be094d710215682fa6e75cdc8f6a0d85" => :yosemite
    sha256 "f17524a925427db8e23c9f7fc2b5e45f4ff7711ce4d4bc8d3eea8d6cd2869408" => :mavericks
    sha256 "cf1ee9e242dc841843fdde936a7d21b41f89e4c93f287ef8cae59da166f5c405" => :mountain_lion
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
