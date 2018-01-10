class Plink < Formula
  desc "Whole genome association analysis toolset"
  homepage "http://zzz.bwh.harvard.edu/plink/"
  url "http://zzz.bwh.harvard.edu/plink/dist/plink-1.07-src.zip"
  sha256 "4af56348443d0c6a1db64950a071b1fcb49cc74154875a7b43cccb4b6a7f482b"
  # tag "bioinformatics"
  # doi "10.1086/519795"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "92beceeafe1e15d5a0a4e6e6d78c9208256c402508f246035464c5842a9058d2" => :el_capitan
    sha256 "5e6555322bafaa569abacea7e62bded2ecfdd2ac3a01a79d6f82cf7e0a93238e" => :yosemite
    sha256 "40506cd63be7f7fd9829f73de28d2f2ab5fccbd28a5eaa76d1146fd46316f0ee" => :mavericks
    sha256 "e7de28c47171e77be9023fd4ced2a7b860be794811982cac768c58154e16fa60" => :x86_64_linux
  end

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      Old versions of clang are missing some symbols for
      exception unwinding (Homebrew/science issue #4234).
      EOS
  end

  # allows plink to build with clang and new versions of gcc
  # borrowed from Debian; discussion at:
  # https://lists.debian.org/debian-mentors/2012/04/msg00410.html
  patch :DATA

  # plink delays in some circumstances due to webcheck timeout
  # build option to skip webcheck
  option "without-webcheck", "Build without default version webcheck"

  def install
    make_args = OS.mac? ? ["SYS=MAC"] : ["FORCE_DYNAMIC=1"]
    make_args << "WITH_WEBCHECK=0" if build.without? "webcheck"
    system "make", *make_args
    pkgshare.install "test.map", "test.ped"
    bin.install "plink"
    doc.install "COPYING.txt", "README.txt"
  end

  test do
    system "#{bin}/plink", "--file", pkgshare/"test"
  end
end
__END__
diff --git a/elf.cpp b/elf.cpp
index ec2ed3d..49bda44 100644
--- a/elf.cpp
+++ b/elf.cpp
@@ -1175,10 +1175,10 @@ void Plink::elfBaseline()
 	  << setw(8) << gcnt << " "
 	  << setw(8) << (double)cnt / (double)gcnt << "\n";
 
-      map<int,int>::iterator i = chr_cnt.begin();
-      while ( i != chr_cnt.end() )
+      map<int,int>::iterator i_iter = chr_cnt.begin();
+      while ( i_iter != chr_cnt.end() )
 	{
-	  int c = i->first;
+	  int c = i_iter->first;
 	  int x = chr_cnt.find( c )->second;
 	  int y = chr_gcnt.find( c )->second;
 	  
@@ -1189,7 +1189,7 @@ void Plink::elfBaseline()
 	      << setw(8) << y << " "
 	      << setw(8) << (double)x / (double)y << "\n";
 	  
-	  ++i;
+	  ++i_iter;
 	}
       
     }
diff --git a/idhelp.cpp b/idhelp.cpp
index a9244fa..8353c9e 100644
--- a/idhelp.cpp
+++ b/idhelp.cpp
@@ -772,12 +772,12 @@ void IDHelper::idHelp()
       for (int j = 0 ; j < jointField.size(); j++ )
 	{
 	  set<IDField*> & jf = jointField[j];
-	  set<IDField*>::iterator j = jf.begin();
+	  set<IDField*>::iterator j_iter = jf.begin();
 	  PP->printLOG(" { ");
-	  while ( j != jf.end() )
+	  while ( j_iter != jf.end() )
 	    {
-	      PP->printLOG( (*j)->name + " " );
-	      ++j;
+	      PP->printLOG( (*j_iter)->name + " " );
+	      ++j_iter;
 	    }
 	  PP->printLOG(" }");
 	}
diff --git a/sets.cpp b/sets.cpp
index 3a8f92f..adef60f 100644
--- a/sets.cpp
+++ b/sets.cpp
@@ -768,11 +768,11 @@ vector_t Set::profileTestScore()
       //////////////////////////////////////////////
       // Reset original missing status
 
-      vector<Individual*>::iterator i = PP->sample.begin();
-      while ( i != PP->sample.end() )
+      vector<Individual*>::iterator i_iter = PP->sample.begin();
+      while ( i_iter != PP->sample.end() )
 	{
-	  (*i)->missing = (*i)->flag;
-	  ++i;
+	  (*i_iter)->missing = (*i_iter)->flag;
+	  ++i_iter;
 	}
 
       ////////////////////////////////////////////////
