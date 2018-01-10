class Populations < Formula
  desc "Individual and population distances, and file conversions"
  homepage "https://bioinformatics.org/~tryphon/populations/"
  url "https://launchpad.net/~olivier-langella/+archive/ubuntu/ppa/+files/populations_1.2.33-2.tar.gz"
  sha256 "bea8ba96e6ed2b1e193194564475458a5bdcd23e1bb3a9d93f27c9a94797124f"
  revision 1
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "9f95976745be9f265339f36966a5d4b4c7c94046fd86bb7ffd9ba43d20520d8b" => :sierra
    sha256 "6c2835403b79a0583bc27f7b3dcdac55db397091daa612f386aa71fc8b0cc930" => :el_capitan
    sha256 "996d10aaa6c180071e8e1f4220dd9b00b22e1c32ad412bb35f3ca0da91af8510" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "qt"

  # Fix a compiler error.
  patch :DATA

  # Use qt5
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3a87627/populations/use-qt5.patch"
    sha256 "dbfa52b6354556fc15b87f259a8463ea4be605eab26587395eb95c2aec0129c1"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_PREFIX_PATH=#{Formula["qt5"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "echo 0 | #{bin}/populations"
  end
end

__END__
diff --git a/src/vecteurs.h b/src/vecteurs.h
index 2279570..ce70e59 100644
--- a/src/vecteurs.h
+++ b/src/vecteurs.h
@@ -86,7 +86,7 @@ public:
 	}
 
 	void Suppr(unsigned long pos) {
-		erase(vector<T>::begin() + pos);
+		this->erase(vector<T>::begin() + pos);
 	}
 
 };
