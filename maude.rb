class Maude < Formula
  desc "reflective language for equational and rewriting logic specification"
  homepage "http://maude.cs.illinois.edu"
  url "http://maude.cs.illinois.edu/w/images/d/d8/Maude-2.7.1.tar.gz"
  sha256 "b1887c7fa75e85a1526467727242f77b5ec7cd6a5dfa4ceb686b6f545bb1534b"

  bottle do
    cellar :any
    sha256 "4483de1d92e6eadfac788f22bd6fcb2eb29161b2de9f4debafde0572bd8be542" => :el_capitan
    sha256 "ba6cf045460330fd734a17f6a9eab4fef171ff4f3ce7985a258d974d374f05d0" => :yosemite
    sha256 "56aac9af714615769ca7c06ceb738f11050b7c38e70f1e47675e900984be90e9" => :mavericks
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
