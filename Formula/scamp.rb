class Scamp < Formula
  homepage "https://www.astromatic.net/software/scamp"
  url "https://www.astromatic.net/download/scamp/scamp-2.0.4.tar.gz"
  sha256 "cbcd57f5042feefa081dc0c5ff07f7f50114a7ef41e79c060ed163caae119d41"
  revision 1

  bottle do
    sha256 "9e275906387075695bda5173a0464052db905f9ace8173a7fe4760e9109b5f37" => :el_capitan
    sha256 "20060cd25e872112b131e3fa1839e5c8f87173812f738428b4c0829fdde9996b" => :yosemite
    sha256 "32fa1439fad65d97d82fd8c5a23d64ddff5b3dec04e530800ff680444c803bf2" => :mavericks
  end

  depends_on "fftw"
  depends_on "cdsclient"
  depends_on "plplot" => :recommended
  depends_on "autoconf" => :build

  # these patches collectively make the changes needed to compile with the Accelerate
  # framework for linear algebra routines.
  patch do
    # make macro file for autoconf to enable Accelerate lib
    url "https://gist.githubusercontent.com/mwcraig/e04cc85ab7972f7df23b/raw/f4625508784e75c7b3ce11d8a578589425533282/acx_accelerate.m4.diff"
    sha256 "5d9dcad73169b527903c67f2bcf415019f0a01a90f8c2185c6a4482f587279e3"
  end
  patch do
    # Patch configure.ac to see new macro
    url "https://gist.githubusercontent.com/mwcraig/c47559059922a5779f67/raw/1c70c9a9540ff882cb6773b50de69ef180f4bfd5/configure.ac.diff"
    sha256 "7be2e9ccca725b975b593609405e50406e35dcd3dcdcb06fd5431f77dafd2a46"
  end
  patch do
    # change name/arguments of LAPACK functions from ATLAS to Accelerate, and add include file
    url "https://gist.githubusercontent.com/mwcraig/a447f855f31a81cd7930/raw/4bc72d9e703ba7dc68e83f06b2e504212eddcd28/c_code.diff"
    sha256 "1cc06ece21d7367cf3a52216a587440b639b6b2776676a2975061dab3e1307a7"
  end

  # Separate counter increment from line on which it is used as index to prevent
  # a segfault.
  patch do
    url "https://gist.githubusercontent.com/mwcraig/48da565e91669bf1b93a/raw/5e4ad72f6626e7866b733546f89d00b0dfe70434/field.c.diff"
    sha256 "cb854791d9f71f9fe675f86baeb595abf099a4fedd5df5d14d422f1f74fa2ec7"
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
