class RGui < Formula
  homepage "http://cran.r-project.org/bin/macosx/"
  desc "R.app Cocoa GUI for the R Programming Language"
  url "http://cran.r-project.org/bin/macosx/Mac-GUI-1.66.tar.gz"
  sha256 "dc90e0ebb44d7ffa04fb804a145a477518e38b2e45ddbd64a2bcbd8a5067cc4a"

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"

  bottle do
    cellar :any
    sha256 "761188e8c515210a43c42ab973a8725d22b60b169dd727cc7acb6122ac6b0e0a" => :yosemite
    sha256 "5c42473e024cec2a5ea63d68633c86ddda318c53f6c17e6d250c085db4d1fe06" => :mavericks
    sha256 "0e4a41d4daf27364dd9b03a7d7997cbea346c96b5bac1db72898e5db2617545e" => :mountain_lion
  end

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
