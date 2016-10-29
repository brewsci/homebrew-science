class Nanopolish < Formula
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  # doi "10.1038/nmeth.3444"
  # tag "bioinformatics"
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
    sha256 "ee8737e9493ecce6d0c81f0bc92582639949e730ac7feb9d653f6d2a17997de8" => :el_capitan
    sha256 "601ad02e5c2a715c4c9fa318a03fae552d95db30228a8b5c5db1c865c82e49af" => :yosemite
    sha256 "0045913993348be5d4189fd87f1643890a8835f8adc8be349326e22db1b1d592" => :mavericks
    sha256 "15a7e625a3e063fdb3d1dfa2d4b9bcb1ce03d9dcb9208ece78ef220a2c0a113f" => :x86_64_linux
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
