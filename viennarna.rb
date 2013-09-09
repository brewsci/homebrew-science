require 'formula'

class Viennarna < Formula
  homepage 'http://www.tbi.univie.ac.at/~ronny/RNA/'
  url 'http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.3.tar.gz'
  sha256 'b2cd1141fada1f33dbf334fc0e797ef45939ce31d80b7da28fa22c309a39d767'

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
