require "formula"

class Plink < Formula
  url "http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-src.zip"
  homepage "http://pngu.mgh.harvard.edu/~purcell/plink/"
  sha1 "d41a2d014ebc02bf11e5235292b50fad6dedd407"

  # allows plink to build with clang and new versions of gcc
  # borrowed from Debian; discussion at:
  # https://lists.debian.org/debian-mentors/2012/04/msg00410.html
  patch :DATA

  # plink delays in some circumstances due to webcheck timeout
  # build option to skip webcheck
  option "without-webcheck", "Build without default version webcheck"

  def install
    ENV.deparallelize
    inreplace "Makefile", "WEBCHECK = 1", "WEBCHECK =" if build.without? "webcheck"

    make_args = (OS.mac?) ? %W[SYS=MAC] : []
    system "make", *make_args
    (share+"plink").install %w{test.map test.ped}
    bin.install "plink"
  end

  test do
    system "plink", "--file", prefix/"share/plink/test"
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
