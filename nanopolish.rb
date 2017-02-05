class Nanopolish < Formula
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  # doi "10.1038/nmeth.3444"
  # tag "bioinformatics"
  revision 1
  head "https://github.com/jts/nanopolish.git"

  stable do
    url "https://github.com/jts/nanopolish.git",
        :tag => "v0.5.0",
        :revision => "758d81a330860e82a24570ef5e6005982b095b49"

    # upstream commit "remove unused function, closes #57"
    patch do
      url "https://github.com/jts/nanopolish/commit/c4ada9f.patch"
      sha256 "d427641e4007fcc78013ffc170be68a6158674bf2d313c9a5547242ffee9c6de"
    end
  end

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

  # use Homebrew eigen not the one upstream wants to fetch with wget
  patch :DATA

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
