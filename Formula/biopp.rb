class Biopp < Formula
  desc "Bio++ is a set of C++ libraries for Bioinformatics."
  homepage "http://biopp.univ-montp2.fr"
  url "http://biopp.univ-montp2.fr/repos/sources/bpp-phyl-omics-2.2.0.tar.gz"
  sha256 "a48f4c6f0ea1758c1f6dc8a262d5cbad95769739d46ce9af08527107a548bfaa"

  bottle do
    cellar :any
    rebuild 2
    sha256 "0a334099d68f8bd0edad8d0d92b1000ff966342b7916e87ddf50c327577625c3" => :sierra
    sha256 "1f0e4aa50929c5779cc07fcbfd0f6bc65aaba413bdeeeec0422b9a7ab49cc5a2" => :el_capitan
    sha256 "cf17b2874d780309086794cda9d5c6d16d0c95cd47013b1cc001ca5ebfade78f" => :yosemite
  end

  depends_on "cmake" => :build

  resource "bppcore" do
    url "http://biopp.univ-montp2.fr/repos/sources/bpp-core-2.2.0.tar.gz"
    sha256 "aacd4afddd1584ab6bfa1ff6931259408f1d39958a0bdc5f78bf1f9ee4e98b79"
  end

  resource "bppseq" do
    url "http://biopp.univ-montp2.fr/repos/sources/bpp-seq-2.2.0.tar.gz"
    sha256 "0927d7fb0301c1b99a7353d5876deadb4a3040776cc74e8fe1c366fe920e7b6b"
  end

  resource "bppphyl" do
    url "http://biopp.univ-montp2.fr/repos/sources/bpp-phyl-2.2.0.tar.gz"
    sha256 "f346d87bbc7858924f3c99d7d74eb4a1f7a1b926746c68d8c28e07396c64237b"
  end

  resource "bpppopgen" do
    url "http://biopp.univ-montp2.fr/repos/sources/bpp-popgen-2.2.0.tar.gz"
    sha256 "f489a42b6d16b747af63f69ac1681d6b5de1b5b4511a2ac313f187a58fa5ede1"
  end

  resource "bppseqomics" do
    url "http://biopp.univ-montp2.fr/repos/sources/bpp-seq-omics-2.2.0.tar.gz"
    sha256 "1cc6a4bc256bbb90d3371c45b0b4b6be6503e1bf5ce702052875ac1cb4b9a13b"
  end

  resource "bppraa" do
    url "http://biopp.univ-montp2.fr/repos/sources/bpp-raa-2.2.0.tar.gz"
    sha256 "c7ec73a5af84808362f301479c548b6a01c47a66065b28a053ff8043409e861a"
  end

  def install
    %w[bppcore bppseq bppphyl bpppopgen bppseqomics bppraa].each do |r|
      resource(r).stage do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args
          system "make", "#{r}-shared", "#{r}-static"
          system "make", "install"
        end
      end
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "bppphylomics-shared", "bppphylomics-static"
      system "make", "install"
    end
  end

  test do
    (testpath/"bpp-phyl-test.cpp").write <<-EOS.undent
      #include <iostream>
      using namespace std;
      #include <Bpp/Seq/Alphabet.all>
      using namespace bpp;
      int main(int args, char ** argv) {
          try {
              cout << "Hello World!" << endl;
              Alphabet *alphabet = new DNA();
              cout << "Playing with alphabet " << alphabet->getAlphabetType() << endl;
              string state = "A";
              bool test = alphabet->isCharInAlphabet("A");
              cout << "Test for state " << state << ": " << (test ? ":)" : ":(") << endl;
              if(test) cout << state << " actually stands for " << alphabet->getName(state) << endl;
              cout << "Numbers of characters: " << alphabet->getNumberOfChars() << endl;
              cout << "Numbers of types     : " << alphabet->getNumberOfTypes() << endl;
              cout << "Size of the alphabet : " << alphabet->getSize()          << endl;
              vector<string> states = alphabet->getSupportedChars();
              cout << "Char	Int" << endl;
              for(unsigned int i = 0; i < states.size(); i++) {
                  cout << states[i] << "	" << alphabet->charToInt(states[i]) << endl;
              }
              delete alphabet;
          } catch(Exception& e) {
            cout << "Bio++ exception:" << endl;
            cout << e.what() << endl;
            return(-1);
          } catch(exception& e) {
            cout << "Any other exception:" << endl;
            cout << e.what() << endl;
            return(-1);
          }
          return(0);
      }
    EOS
    libs = %W[-lbpp-core -lbpp-seq -lbpp-phyl -lbpp-raa -lbpp-seq-omics
              -lbpp-phyl-omics -lbpp-popgen]
    system ENV.cxx, "-o", "test", "bpp-phyl-test.cpp",
           "-I#{include}", "-L#{lib}", *libs
    system "./test"
  end
end
