require 'formula'

class Viennarna < Formula
  homepage 'http://www.tbi.univie.ac.at/~ivo/RNA/'
  url 'http://www.tbi.univie.ac.at/~ronny/RNA/ViennaRNA-2.1.2.tar.gz'
  sha256 '8aee684aa39f6588379071d50a7a5f6779fd84fedc8111546042464f0013570f'

  option 'with-perl', 'build and install Perl interfaces'

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
