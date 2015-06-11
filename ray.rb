class Ray < Formula
  desc "Parallel genome assemblies for parallel DNA sequencing"
  homepage "http://denovoassembler.sourceforge.net"
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "81aded510ff259906110a510b7c79b46e7c540c059da790bf7a2809fc178654e" => :yosemite
    sha256 "eb8796487157f5077c4c692a6b3a2e78d9c7e278f8ae831cbc55f4862d4e2513" => :mavericks
    sha256 "a82a34c37f1c48d655921ff409eb8b2a3db666743c53f31dbedee0cd5f2ddff3" => :mountain_lion
  end

  # doi "10.1089/cmb.2009.0238"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/denovoassembler/Ray-2.3.1.tar.bz2"
  sha256 "3122edcdf97272af3014f959eab9a0f0e5a02c8ffc897d842b06b06ccd748036"

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
