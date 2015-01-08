class LumpySv < Formula
  homepage "https://github.com/arq5x/lumpy-sv"
  # doi "10.1186/gb-2014-15-6-r84"
  # tag "bioinformatics"
  url "https://github.com/arq5x/lumpy-sv/releases/download/0.2.9/lumpy-sv-0.2.9.tar.gz"
  sha1 "3ca24aed2b5a57a5e8a55f2f65057520474fb77c"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "76b8040a6bb5586829cee50723ada9b0a08c95db" => :yosemite
    sha1 "347569ef2f558c13cc860857113e287ed046fb31" => :mavericks
    sha1 "9a951d727f67fc9a315d26a260d0ad4f1b69cd6f" => :mountain_lion
  end

  depends_on "bamtools" => :recommended
  depends_on "samtools" => :recommended
  depends_on "bedtools" => :recommended
  depends_on "bwa" => :optional
  depends_on "novoalign" => :optional
  depends_on "yaha" => :optional

  def install
    ENV.deparallelize
    system "make"
    bin.install "bin/lumpy"
    (share/"lumpy-sv").install Dir["scripts/*"]
  end

  test do
    system "#{bin}/lumpy 2>&1 |grep -q structural"
  end
end
