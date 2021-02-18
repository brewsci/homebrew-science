class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "http://mallet.cs.umass.edu/"
  url "http://mallet.cs.umass.edu/dist/mallet-2.0.8.tar.gz"
  sha256 "5b2d6fb9bcf600b1836b09881821a6781dd45a7d3032e61d7500d027a5b34faf"
  head "https://github.com/mimno/Mallet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, sierra:       "da32cef7b10fcbfc1f5fc7878f779a5000d88f3363342b6c9ff1830f29d85803"
    sha256 cellar: :any_skip_relocation, el_capitan:   "f870d8dac822eeda26296f069d488547cb415c2eaaeb0fd0e822595308c0b390"
    sha256 cellar: :any_skip_relocation, yosemite:     "f870d8dac822eeda26296f069d488547cb415c2eaaeb0fd0e822595308c0b390"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d2556a240155cfc90259839cb5861d7c4d1e8e58d3210b934bbd5b1cf5897495"
  end

  # tag "machine learning"

  depends_on "openjdk"

  def install
    rm Dir["bin/*.{bat,dll,exe}"] # Remove all windows files
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  test do
    system "#{bin}/mallet | grep Mallet"
  end
end
