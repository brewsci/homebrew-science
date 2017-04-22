class MacOSRequirement < Requirement
  fatal true
  satisfy(build_env: false) { OS.mac? }
  def message
    "macOS is required."
  end
end

class RGui < Formula
  desc "R.app Cocoa GUI for the R Programming Language"
  homepage "https://cran.r-project.org/bin/macosx/"
  url "https://cran.r-project.org/bin/macosx/Mac-GUI-1.68.tar.gz"
  sha256 "7dff17659a69e3c492fdfc3fb765e3c9537157d50b6886236bee7ad873eb416d"
  revision 2

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"

  bottle do
    cellar :any
    sha256 "4f687e5d127ec617aad99cda323022ac99b798f016d487f2d0b5f7eaa4476370" => :sierra
    sha256 "9a007116440b26de83a304e0bccf75d27303a9fab772aae6ccc6aaee1c9cd466" => :el_capitan
    sha256 "0cc30cd89420a725d599046b2898d625047af60749246b00339799bf2b164b85" => :yosemite
  end

  depends_on MacOSRequirement
  depends_on :xcode => :build
  depends_on :macos => :snow_leopard
  depends_on :arch => :x86_64

  depends_on "r"

  def install
    # ugly hack to get updateSVN script in build to not fail
    cp_r cached_download/".svn", buildpath if build.head?

    r_opt_prefix = Formula["r"].opt_prefix

    # xcodebuild must be fed with MACOSX_DEPLOYMENT_TARGET when SDK is not
    # available for the installed system version
    xcodebuild "-target", "R", "-configuration", "Release", "SYMROOT=build",
               "HEADER_SEARCH_PATHS=#{r_opt_prefix}/R.framework/Headers",
               "OTHER_LDFLAGS=-F#{r_opt_prefix}",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    prefix.install "build/Release/R.app"
  end
end
