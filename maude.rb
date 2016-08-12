class Maude < Formula
  desc "reflective language for equational and rewriting logic specification"
  homepage "http://maude.cs.illinois.edu"
  url "http://maude.cs.illinois.edu/w/images/d/d8/Maude-2.7.1.tar.gz"
  sha256 "b1887c7fa75e85a1526467727242f77b5ec7cd6a5dfa4ceb686b6f545bb1534b"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbdd5374a68789987374995e612f268dcda8afd8f6e493744884943a0f1ac7cb" => :el_capitan
    sha256 "3280a654d8d4248d8aaace8667f51e645e812b5cc2a87d1f3e24572578de238f" => :yosemite
    sha256 "3826c4e7c7361a826d10db6aafc82f58681968b1427658338e717669dd714ee3" => :mavericks
  end

  depends_on "gmp"
  depends_on "libbuddy"
  depends_on "libsigsegv"
  depends_on "libtecla"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--without-cvc4"
    system "make", "install"
    (bin/"maude").write_env_script libexec/"bin/maude", :MAUDE_LIB => libexec/"share"
  end

  test do
    input = <<-EOS.undent
      set show stats off .
      set show timing off .
      set show command off .
      reduce in STRING : "hello" + " " + "world" .
    EOS
    expect = %(Maude> result String: "hello world"\nMaude> Bye.\n)
    output = pipe_output("#{bin/"maude"} -no-banner", input)
    assert_equal expect, output
  end
end
