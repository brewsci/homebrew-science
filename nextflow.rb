class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"

  version "0.12.2"
  url "http://www.nextflow.io/releases/v0.12.2/nextflow"
  sha1 "d6637cdb5913e7dbffa6fa8e774e2c73ee3f1ac8"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "d1a995f74179f52db106a2fd7f6ad6fd9518706b" => :yosemite
    sha1 "1209d43c4b6f965f9ea90890aee641412c3b5240" => :mavericks
    sha1 "287cf8196abbd6c11b457793403914333f78bb81" => :mountain_lion
  end

  depends_on :java => "1.7"

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
