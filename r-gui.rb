class RGui < Formula
  desc "R.app Cocoa GUI for the R Programming Language"
  homepage "https://cran.r-project.org/bin/macosx/"
  url "https://cran.r-project.org/bin/macosx/Mac-GUI-1.68.tar.gz"
  sha256 "7dff17659a69e3c492fdfc3fb765e3c9537157d50b6886236bee7ad873eb416d"

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"

  bottle do
    cellar :any
    sha256 "702cac317a1b33ff16f811b796adba76485e77628f854319539e59fc6d9ea826" => :sierra
    sha256 "59d782583a0273c4009c29f9bd935eef5837a79c06875e2cd62a63f6a1d8f29a" => :el_capitan
    sha256 "1ca074f212f3901bd57da0ba6ab35cc78b0cbf3f28796aec2487ad89a43b8c97" => :yosemite
  end

  depends_on :xcode => :build
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
