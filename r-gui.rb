class RGui < Formula
  desc "R.app Cocoa GUI for the R Programming Language"
  homepage "http://cran.r-project.org/bin/macosx/"
  url "http://cran.r-project.org/bin/macosx/Mac-GUI-1.67.tar.gz"
  sha256 "8a565c0268b0194c69ba1c19b4919e802fc63c420a0eb80fa8943e10f053e898"

  head "https://svn.r-project.org/R-packages/trunk/Mac-GUI"
  revision 1

  bottle do
    cellar :any
    sha256 "7da296d529c70c94f88902f0a216c75057095a3d5e0094d6d6fe82a47089de0c" => :el_capitan
    sha256 "b357a5396f7f2eabf7b1d48135666f18b164c49c7cad9bda1066d2a91cbbe9c0" => :yosemite
    sha256 "a1daa51392bf3ab2704fbf6335685d09269514773e0eb5ceda8ae4873513092e" => :mavericks
  end

  depends_on :xcode
  depends_on macos: :snow_leopard
  depends_on arch: :x86_64

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
