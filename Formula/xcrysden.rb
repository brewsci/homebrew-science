class Xcrysden < Formula
  desc "Crystalline and molecular structure visualisation program"
  homepage "http://www.xcrysden.org/"
  url "http://www.xcrysden.org/download/xcrysden-1.5.60.tar.gz"
  sha256 "a695729f1bb3e486b86a74106c06a392c8aca048dc6b0f20785c3c311cfb2ef4"

  depends_on "gcc"
  depends_on "tcl-tk-x11"
  depends_on "fftw"
  depends_on "wget" => :build
  depends_on :x11

  # Fix togl -accum false in Tcl and modify Make.sys
  patch do
    url "https://gist.githubusercontent.com/specter119/4f630e538d39edcf67ec742f78c23aab/raw/464f0a813f209df5bd008b3ef4b2394e86117439/xcrysden-homebrew.patch"
    sha256 "943241a5bc07e8a638cb09d7ee6e4ffb3705e567d7a7c411b2d5aebb9ce6c285"
  end

  def install
    cp "system/Make.macosx-x11", "Make.sys"

    ENV.deparallelize
    system "make", "xcrysden"

    args = %W[
      prefix=#{prefix}
    ]

    system "make", *args, "install"
  end

  def caveats
    <<~EOS
      XCrySDen can be user-customized. Create $HOME/.xcrysden/ directory
      and copy the "custom-definitions" and "Xcrysden_resources" files
      from the Tcl/ subdirectory of the XCrySDen root directory.
      These can be then modified according to user preference.

      For more info about customization, see: http://www.xcrysden.org/doc/custom.html
    EOS
  end

  test do
    system bin/"xcrysden", "--version"
  end
end
