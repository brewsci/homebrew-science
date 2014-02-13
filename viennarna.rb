require 'formula'

class Viennarna < Formula
  homepage 'http://www.tbi.univie.ac.at/~ronny/RNA/'
  url 'http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.6.tar.gz'
  sha1 '04fd80cf659547959b9b90f59e04f9734e5e43ce'

  option 'with-perl', 'Build and install Perl interface'

  def install
    ENV['ARCHFLAGS'] = "-arch x86_64"
    args = ["./configure", "--disable-debug", "--disable-dependency-tracking",
                      "--prefix=#{prefix}", "--disable-openmp"]
    args << '--without-perl' unless build.include? 'with-perl'
    system(*args)
    system "make install"
  end

  test do
    system "echo 'CGACGUAGAUGCUAGCUGACUCGAUGC' | #{bin}/RNAfold --MEA -p"
  end
end
