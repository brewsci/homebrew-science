require 'formula'

class Abyss < Formula
  homepage 'http://www.bcgsc.ca/platform/bioinfo/software/abyss'
  #doi '10.1101/gr.089532.108'
  url 'https://github.com/bcgsc/abyss/releases/download/1.5.0/abyss-1.5.0.tar.gz'
  sha1 '3340a22889604b2ef0d12db962896afc3d72da1b'

  head do
    url 'https://github.com/bcgsc/abyss.git'

    depends_on :autoconf => :build
    depends_on :automake => :build
    depends_on 'multimarkdown' => :build
  end

  option 'disable-popcnt', 'do not use the POPCNT instruction'
  MAXK = [32, 64, 96, 128, 256, 512]
  MAXK.each do |k|
    option "enable-maxk=#{k}", "set the maximum k-mer length to #{k}"
  end

  # Only header files are used from these packages, so :build is appropriate
  depends_on 'boost' => :build
  depends_on 'google-sparsehash' => :build
  depends_on :mpi => [:cc, :recommended]

  # strip breaks the ability to read compressed files.
  skip_clean 'bin'

  def install
    system "./autogen.sh" if build.head?
    args = [
      '--disable-dependency-tracking',
      "--prefix=#{prefix}"]
    args << '--disable-popcnt' if build.include? 'disable-popcnt'
    MAXK.each do |k|
      args << "--enable-maxk=#{k}" if build.include? "enable-maxk=#{k}"
    end
    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/ABYSS", "--version"
  end
end
