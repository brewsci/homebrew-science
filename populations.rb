require 'formula'

class Populations < Formula
  homepage 'http://bioinformatics.org/~tryphon/populations/'
  url 'https://launchpad.net/~olivier-langella/+archive/ppa/+files/populations_1.2.33-2.tar.gz'
  sha1 'ff190be19352e2bb66f7decb87aed311b924529c'
  version '1.2.33-2'

  depends_on 'cmake' => :build
  depends_on 'gettext'
  depends_on 'qt'

  def patches
    # Fix a compiler error.
    DATA
  end

  def install
    system 'cmake', '.', *std_cmake_args
    system 'make', 'install'
  end

  def test
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
