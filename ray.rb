class Ray < Formula
  desc "Parallel genome assemblies for parallel DNA sequencing"
  homepage "http://denovoassembler.sourceforge.net"
  bottle do
    cellar :any
    sha256 "d7619f3b6326643113fabfcbfe2c2ed6db57c8748e6679491050b1bdecadcb01" => :el_capitan
    sha256 "6fc8e695923a3492203d41614d6ccbe685f30645110e9788a64076eab1b52928" => :yosemite
    sha256 "190bc6ad483f41afacd886718c750e960d1b828ac0901ea9bb625f558c70bf42" => :mavericks
  end

  # doi "10.1089/cmb.2009.0238"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/denovoassembler/Ray-2.3.1.tar.bz2"
  sha256 "3122edcdf97272af3014f959eab9a0f0e5a02c8ffc897d842b06b06ccd748036"
  revision 1

  head "https://github.com/sebhtml/ray.git"

  resource "RayPlatform" do
    # homepage "https://github.com/sebhtml/RayPlatform"
    url "https://github.com/sebhtml/RayPlatform.git"
  end

  depends_on :mpi => :cxx

  fails_with :llvm do
    build 2336
    cause '"___gxx_personality_v0" ... ld: symbol(s) not found for architecture x86_64'
  end

  fails_with :gcc do
    build 5666
    cause "error: wrong number of arguments specified for '__deprecated__' attribute"
  end

  def install
    if build.head?
      rm "RayPlatform" # Remove the broken symlink
      resource("RayPlatform").stage buildpath/"RayPlatform"
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install"
    # The binary "Ray" is installed in the prefix, but we want it in bin:
    bin.install prefix/"Ray"
  end

  test do
    system bin/"Ray", "--version"
  end
end
