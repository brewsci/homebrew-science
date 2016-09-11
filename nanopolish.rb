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
    sha256 "1c549b3531199a61f5d3614a81249c9ddc7971a4b82db3f32047283e5f44da78" => :el_capitan
    sha256 "7ece6dfcee6cbce122e77df08d45839a8ecc5fc8fd6fa7e69ea4c6adc4aa5d27" => :yosemite
    sha256 "80756bb5bccf558984a0b8153a687e07f97c845a13cc2d8bc8d890698895f76d" => :mavericks
    sha256 "ecf4857a09dce1ccd7e7a658596e61644b515ceeb9947819c028cc78341d47db" => :x86_64_linux
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
