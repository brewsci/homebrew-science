require 'formula'

class Viennarna < Formula
  homepage 'http://www.tbi.univie.ac.at/~ronny/RNA/'
  url 'http://www.tbi.univie.ac.at/~ronny/RNA/packages/source/ViennaRNA-2.1.5.tar.gz'
  sha256 '2d02103b6a5d1536df26607ee00b8be364758f2cb796aeb010517c311e861d58'

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
