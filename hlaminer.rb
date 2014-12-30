class Hlaminer < Formula
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer"
  #doi "10.1186/gm396"
  #tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer/releases/1.1/HLAminer.tar.gz"
  version "1.1.0"
  sha1 "d1c97731885bc7a12f67027e0e0b01c8bfb03bd2"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "d5a92d02d1b447cfa49292351867059408bb07d4" => :yosemite
    sha1 "764cc41b5fbc89ab28df3bdd0f1149d125a0d168" => :mavericks
    sha1 "1cd5b574c6baf25d6c2089a2f6985ff877916609" => :mountain_lion
  end

  depends_on "blast"
  depends_on "tasr"

  def install
    # Conflicts with tasr
    rm "bin/TASR"

    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/HLAminer.pl |grep hlaminer"
  end
end
