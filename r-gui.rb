class RGui < Formula

  homepage "http://cran.r-project.org/bin/macosx/"
  desc "R.app Cocoa GUI for the R Programming Language"
  url "http://cran.r-project.org/bin/macosx/Mac-GUI-1.66.tar.gz"
  sha256 "dc90e0ebb44d7ffa04fb804a145a477518e38b2e45ddbd64a2bcbd8a5067cc4a"

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"

  depends_on :xcode
  depends_on :macos => :snow_leopard
  depends_on :arch => :x86_64

  depends_on "r"

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
