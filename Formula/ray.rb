class Ray < Formula
  desc "Parallel genome assemblies for parallel DNA sequencing"
  homepage "https://denovoassembler.sourceforge.io/"
  # doi "10.1089/cmb.2009.0238"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/denovoassembler/Ray-2.3.1.tar.bz2"
  sha256 "3122edcdf97272af3014f959eab9a0f0e5a02c8ffc897d842b06b06ccd748036"
  revision 2

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  head "https://github.com/sebhtml/ray.git"

  resource "RayPlatform" do
    # homepage "https://github.com/sebhtml/RayPlatform"
    url "https://github.com/sebhtml/RayPlatform.git"
  end

  depends_on :mpi => :cxx

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
