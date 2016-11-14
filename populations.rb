class Populations < Formula
  desc "individual and population distances, and file conversions"
  homepage "http://bioinformatics.org/~tryphon/populations/"
  url "https://launchpad.net/~olivier-langella/+archive/ubuntu/ppa/+files/populations_1.2.33-2.tar.gz"
  sha256 "bea8ba96e6ed2b1e193194564475458a5bdcd23e1bb3a9d93f27c9a94797124f"
  revision 1
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "d2f69b0c356ac9361bb3750a6f76417ed730db2c3b7f18b496fcee72f7a98dbd" => :yosemite
    sha256 "0c2fae734364600434ebc4f059776372e19b16c2e176876e74b3de0c83e3caaf" => :mavericks
    sha256 "dd0f5bbb215bf76eb1f3593e7c4ffb885af8fbfddcf71467232941e637be69c5" => :mountain_lion
    sha256 "97d5ea179a80f8b435efaf00a37f2faa727890232c57237ce411da4af2087853" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "qt5"

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
