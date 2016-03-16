class RGui < Formula
  desc "R.app Cocoa GUI for the R Programming Language"
  homepage "http://cran.r-project.org/bin/macosx/"
  url "http://cran.r-project.org/bin/macosx/Mac-GUI-1.67.tar.gz"
  sha256 "8a565c0268b0194c69ba1c19b4919e802fc63c420a0eb80fa8943e10f053e898"

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"

  bottle do
    cellar :any
    sha256 "97d439b476faf5ac4ed4a8641deea0509c866c23d2948b75ca324a6db16df340" => :el_capitan
    sha256 "98fb41fe03283039f84d2914121747ac8f14bd5dad02716f6dce4e8390430b6a" => :yosemite
    sha256 "d538f109fa6bf2c933f5d202796682e214462d177839c579a5abf04aa9e06e13" => :mavericks
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
