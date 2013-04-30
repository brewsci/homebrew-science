require 'formula'

class Viennarna < Formula
  homepage 'http://www.tbi.univie.ac.at/~ivo/RNA/'
  url 'http://www.tbi.univie.ac.at/~ronny/RNA/ViennaRNA-2.1.1.tar.gz'
  sha256 'bfea440dface4562d5dfb0a1c83bf226c0697bb18aacae0dc84c555282cedebe'

  option 'with-perl', 'build and install Perl interfaces'

  def install
    ENV['ARCHFLAGS'] = "-arch x86_64"
    args = ["./configure", "--disable-debug", "--disable-dependency-tracking",
                      "--prefix=#{prefix}", "--disable-openmp"]
    args << '--without-perl' unless build.include? 'with-perl'
    system(*args)
    system "make install"
  end

  def test
    system "echo 'GGGGCUAUAGCUCAGCUGGGAGAGCGCUUGCAUGGCAUGCAAGAGGUCAGCGGUUCGAUCCCGCUUAGCUCCACCA' |RNAfold"
  end
end
