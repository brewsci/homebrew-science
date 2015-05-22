class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.14.tar.gz"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"
  sha256 "2411c4f56f477b42dff54db2b7ffc0b7cf53bb9778d54982595c64cc69c40fc1"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "29e57f8aec83207cccfe3727cbba9d68f1beee7667cab889c7edf99fa95dc52f" => :yosemite
    sha256 "564079bfa0b8cd88cd75c556a26c7f9d7c7b35d96410a90c81effd547ba5bf99" => :mavericks
    sha256 "c0aa12e957941953ec017b13e8f82a7d100df48172433117d3d57d3b6375092b" => :mountain_lion
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
