class LumpySv < Formula
  homepage "https://github.com/arq5x/lumpy-sv"
  url "https://github.com/arq5x/lumpy-sv/releases/download/0.2.11/lumpy-sv-0.2.11.tar.gz"
  sha256 "ce2d8d6353cbce1c83a0aaa25a5bd9238f0ebaa8253b873b01bd446290e54379"
  # doi "10.1186/gb-2014-15-6-r84"
  # tag "bioinformatics"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "76b8040a6bb5586829cee50723ada9b0a08c95db" => :yosemite
    sha1 "347569ef2f558c13cc860857113e287ed046fb31" => :mavericks
    sha1 "9a951d727f67fc9a315d26a260d0ad4f1b69cd6f" => :mountain_lion
  end

  depends_on "samblaster" => :optional
  depends_on "samtools" => :optional
  depends_on "sambamba" => :optional
  depends_on "bwa" => :optional

  resource "bamkit" do
    url "https://github.com/cc2qe/bamkit/archive/6b8c20.tar.gz"
    sha256 "98d8180f4b7f5e32deb531cc3562cd3eeed0d2377ca539230f43806281393513"
  end

  def install
    ENV.deparallelize
    inreplace "scripts/lumpyexpress.config" do |s|
      s.change_make_var! "LUMPY_HOME", "#{HOMEBREW_PREFIX}/share/lumpy-sv"
    end
    system "make"
    bin.install "bin/lumpy"
    bin.install Dir["scripts/lumpyexpress*"]
    (pkgshare/"scripts").install Dir["scripts/*"]
    resource("bamkit").stage pkgshare/"scripts/bamkit"
  end

  test do
    system "#{bin}/lumpy 2>&1 |grep -q structural"
    system "#{bin}/lumpyexpress 2>&1 |grep -q lumpyexpress"
  end
end
