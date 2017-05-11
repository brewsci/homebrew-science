class Nanopolish < Formula
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  url "https://github.com/jts/nanopolish.git",
        :tag => "v0.6.0",
        :revision => "bcb46f0ec4d7c60054fad1aeb1028159e0292005"
  head "https://github.com/jts/nanopolish.git"

  # doi "10.1038/nmeth.3444"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "8a002b4ee81454a639a29b73c323f66304a2d44937deb9d9dddb8424e0d27710" => :sierra
    sha256 "714685c444d682963a03fd88a5afe757ea34d964640dd56311e1810ce939fc63" => :el_capitan
    sha256 "30a3bd018ed65ac58a3c345c357d5f3f4af88af4ca3ab09a0fb82f2b60b6ac38" => :yosemite
    sha256 "420e75e483e0a0117cc81f6124b50a2497a23346bb104eb73e09c8e18faf8f17" => :x86_64_linux
  end

  needs :cxx11
  needs :openmp

  depends_on "hdf5"
  depends_on "eigen" => :build

  # Fails to build under yosemite
  depends_on MinimumMacOSRequirement => :el_capitan

  # use Homebrew eigen not the one upstream wants to fetch with wget
  patch :DATA

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/325c6b2390888d6e98083c3e01e961a135092302/nanopolish/nanopolish.patch"
    sha256 "10afe036f2f9919508c8c55c27d756cf4771e7c9f8307aa14e4c71ed3aed8645"
  end

  def install
    ln_s Formula["eigen"].opt_include/"eigen3", "eigen"
    system "make", "HDF5=#{Formula["hdf5"].opt_prefix}"
    prefix.install "scripts", "nanopolish"
    bin.install_symlink "../nanopolish"
  end

  test do
    system bin/"nanopolish", "--help"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 8072faf..6f38c6f 100644
--- a/Makefile
+++ b/Makefile
@@ -69,12 +69,10 @@ lib/libhdf5.a:


 # Download and install eigen if not already downloaded
-EIGEN=eigen/INSTALL
+EIGEN=eigen

 $(EIGEN):
-	wget http://bitbucket.org/eigen/eigen/get/3.2.5.tar.bz2
-	tar -xjvf 3.2.5.tar.bz2
-	mv eigen-eigen-bdd17ee3b1b3 eigen
+	echo "using brew eigen"

 #
 # Source files
