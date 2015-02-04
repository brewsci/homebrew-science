class Pathvisio < Formula
  homepage "http://www.pathvisio.org/"
  # tag "bioinformatics"
  # doi "10.1186/1471-2105-9-399"
  url "http://pathvisio.org/data/releases/current/pathvisio_bin-3.1.3-r3968.tar.gz"
  sha1 "54b14c34464c2714fc4455dd933038f03985ddcd"
  version "3.1.3"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "f31c60620d127906391421d52beb77bb425f7d0c" => :yosemite
    sha1 "c2677391d334b0360c48c39da9dfdf879891f245" => :mavericks
    sha1 "b50a242187b691fc91028ecc15dfb80afcfd34ff" => :mountain_lion
  end

  depends_on :java => "1.7"

  def install
    libexec.install "LICENSE-2.0.txt", "NOTICE.txt", "pathvisio.jar", "pathvisio.sh"
    bin.write_jar_script libexec/"pathvisio.jar", "pathvisio"
    doc.install "readme.txt"
  end

  test do
    system "#{bin}/pathvisio", "-v"
  end
end
