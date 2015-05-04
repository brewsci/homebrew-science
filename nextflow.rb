class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"
  version "0.13.4"
  url "http://www.nextflow.io/releases/v0.13.4/nextflow"
  sha256 "64eae8d4095dd004840afd94a4b30012b26630808adbc78aebf7445061c5271e"
  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "4dd7fdfdd9b55482243382a6305a262d71b25a94a5f3546af1cf056c5d63db26" => :yosemite
    sha256 "ee764c45097a25b8d1897f9b3f9c2a23b7f96ce0ff4698607f9847fe4735eaf0" => :mavericks
    sha256 "68af288c973dd2578de1cded63dd616ec329e442ab85abc5826306fca90f499b" => :mountain_lion
  end

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  def post_install
    system "#{bin}/nextflow", "-download"
  end

  test do
    system "echo \"println 'hello'\" |#{bin}/nextflow -q run - |grep hello"
  end
end
