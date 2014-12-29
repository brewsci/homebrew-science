require "formula"

class Populations < Formula
  homepage "http://bioinformatics.org/~tryphon/populations/"
  #tag "bioinformatics"

  url "https://launchpad.net/~olivier-langella/+archive/ppa/+files/populations_1.2.33-2.tar.gz"
  sha1 "ff190be19352e2bb66f7decb87aed311b924529c"
  version "1.2.33-2"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "d5c96260ab82fe602b674f7d25f6427d53efea82" => :yosemite
    sha1 "b9ff1df51ef395aeacbabc8e7ba1426655125616" => :mavericks
    sha1 "9d71c75bdc9d35619adb006ac05737ce3ddb7136" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "qt"

  # Fix a compiler error.
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
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
