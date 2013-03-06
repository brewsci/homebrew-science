require 'formula'

class Abyss < Formula
  homepage 'http://www.bcgsc.ca/platform/bioinfo/software/abyss'
  url 'http://www.bcgsc.ca/downloads/abyss/abyss-1.3.5.tar.gz'
  sha1 '43c3caceb91f768290cb7a1b70f6b3113b8a36fc'
  head 'https://github.com/sjackman/abyss.git'

  option 'disable-popcnt', 'do not use the POPCNT instruction'

  # Only header files are used from these packages, so :build is appropriate
  if build.head?
    depends_on :autoconf => :build
    depends_on :automake => :build
    depends_on 'multimarkdown' => :build
  end
  depends_on 'boost' => :build
  depends_on 'google-sparsehash' => :build
  depends_on MPIDependency.new(:cc)

  # strip breaks the ability to read compressed files.
  skip_clean 'bin'

  def install
    system "./autogen.sh" if build.head?
    args = [
      '--disable-dependency-tracking',
      "--prefix=#{prefix}"]
    args << '--disable-popcnt' if build.include? 'disable-popcnt'
    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/ABYSS", "--version"
  end
end
