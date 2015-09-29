class Paxtools < Formula
  desc "Java library for accessing and manipulating data in BioPAX format."
  homepage "http://www.biopax.org/paxtools/"
  url "https://downloads.sourceforge.net/project/biopax/paxtools/paxtools-4.3.1.jar"
  sha256 "a3479a09ee55f0c16d97cc6a0c423e71e0f43121757522ec63eb6aee81e0aa56"

  depends_on :java => "1.6"

  def install
    libexec.install "paxtools-#{version}.jar"
    bin.write_jar_script libexec/"paxtools-#{version}.jar", "paxtools"
  end

  test do
    system "#{bin}/paxtools", "help"
  end
end
