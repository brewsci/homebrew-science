class RGui < Formula
  desc "R.app Cocoa GUI for the R Programming Language"
  homepage "https://cran.r-project.org/bin/macosx/"
  url "https://cran.r-project.org/bin/macosx/Mac-GUI-1.68.tar.gz"
  sha256 "7dff17659a69e3c492fdfc3fb765e3c9537157d50b6886236bee7ad873eb416d"

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"

  bottle do
    cellar :any
    sha256 "7da296d529c70c94f88902f0a216c75057095a3d5e0094d6d6fe82a47089de0c" => :el_capitan
    sha256 "b357a5396f7f2eabf7b1d48135666f18b164c49c7cad9bda1066d2a91cbbe9c0" => :yosemite
    sha256 "a1daa51392bf3ab2704fbf6335685d09269514773e0eb5ceda8ae4873513092e" => :mavericks
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
