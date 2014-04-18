require "formula"

class RGui < Formula

  homepage "http://cran.r-project.org/bin/macosx/"
  url "http://cran.r-project.org/bin/macosx/Mac-GUI-1.64.tar.gz"
  sha1 "8c31fb05ad990f0c83e94e1921738e0951624bd9"

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"

  depends_on :xcode
  depends_on :macos => :snow_leopard
  depends_on :arch => :x86_64

  depends_on "r"

  # fix for 1.64 in GUI-tools.R
  patch :DATA if not build.head?

  def install
    # ugly hack to get updateSVN script in build to not fail
    cp_r cached_download/".svn", buildpath if build.head?

    r_opt_prefix = Formula["r"].opt_prefix

    xcodebuild "-target", "R", "-configuration", "Release", "SYMROOT=build",
               "HEADER_SEARCH_PATHS=#{r_opt_prefix}/R.framework/Headers",
               "OTHER_LDFLAGS=-F#{r_opt_prefix}"

    prefix.install "build/Release/R.app"
  end
end

__END__
diff --git a/GUI-tools.R b/GUI-tools.R
index a02b0b3..30383f4 100644
--- a/GUI-tools.R
+++ b/GUI-tools.R
@@ -99,7 +99,7 @@ add.fn("package.manager", function ()
     pkgs.status <- character(length(is.loaded))
     pkgs.status[which(is.loaded)] <- "loaded"
     pkgs.status[which(!is.loaded)] <- " "
-    pkgs.url <- file.path(.find.package(pkgs), "html", "00Index.html")
+    pkgs.url <- file.path(find.package(pkgs, quiet=TRUE), "html", "00Index.html")
     load.idx <-
         .Call("pkgmanager", is.loaded, pkgs, pkgs.desc, pkgs.url)
     toload <- which(load.idx & !is.loaded)
