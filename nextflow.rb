class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"

  version "0.13.1"
  url "http://www.nextflow.io/releases/v0.13.1/nextflow"
  sha1 "ddcae0ac62ae4dc17259a1ceace69ee7c2483cf4"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "2796e3426cf1c3a046964d6c3bb61776810f63db" => :yosemite
    sha1 "60005442faa7450f8904f2b8152080aabf5b9ef7" => :mavericks
    sha1 "b237b096d6c6a82ea6afe90c292f8a5732961357" => :mountain_lion
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
