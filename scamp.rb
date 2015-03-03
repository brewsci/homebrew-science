class Scamp < Formula
  homepage "http://www.astromatic.net/software/scamp"
  url "http://www.astromatic.net/download/scamp/scamp-2.0.4.tar.gz"
  sha256 "cbcd57f5042feefa081dc0c5ff07f7f50114a7ef41e79c060ed163caae119d41"

  depends_on "fftw"
  depends_on "cdsclient"
  depends_on "plplot" => :recommended
  depends_on "autoconf" => :build

  # these patches collectively make the changes needed to compile with the Accelerate
  # framework for linear algebra routines.
  patch do
    # make macro file for autoconf to enable Accelerate lib
    url "https://gist.githubusercontent.com/mwcraig/e04cc85ab7972f7df23b/raw/f4625508784e75c7b3ce11d8a578589425533282/acx_accelerate.m4.diff"
    sha1 "3abc1e8ab3975911897958c21f32e9d89481dc4f"
  end
  patch do
    # Patch configure.ac to see new macro
    url "https://gist.githubusercontent.com/mwcraig/c47559059922a5779f67/raw/1c70c9a9540ff882cb6773b50de69ef180f4bfd5/configure.ac.diff"
    sha1 "76875a49e112c850a562a63dd52a61a63358e071"
  end
  patch do
    # change name/arguments of LAPACK functions from ATLAS to Accelerate, and add include file
    url "https://gist.githubusercontent.com/mwcraig/a447f855f31a81cd7930/raw/4bc72d9e703ba7dc68e83f06b2e504212eddcd28/c_code.diff"
    sha1 "9f564dd691e9223e748e354f6cd8563d3ebce96e"
  end

  # Separate counter increment from line on which it is used as index to prevent
  # a segfault.
  patch do
    url "https://gist.githubusercontent.com/mwcraig/48da565e91669bf1b93a/raw/5e4ad72f6626e7866b733546f89d00b0dfe70434/field.c.diff"
    sha1 "71dd5882106c16fd3599828766fcd5691fd9fca0"
  end

  def install
    system "autoconf"
    system "autoheader"
    system "./configure", "--prefix=#{prefix}", "--enable-accelerate"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "scamp", "-v"
  end
end
