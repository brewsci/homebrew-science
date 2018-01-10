class Paxtools < Formula
  desc "Java library for accessing and manipulating data in BioPAX format"
  homepage "http://www.biopax.org/paxtools/"
  url "https://downloads.sourceforge.net/project/biopax/paxtools/paxtools-5.0.1.jar"
  sha256 "da189a2232719b34276f91f4422572ed8754350a8afdfec3378572cc76b27e40"

  depends_on :java => "1.6"

  def install
    libexec.install "paxtools-#{version}.jar"
    bin.write_jar_script libexec/"paxtools-#{version}.jar", "paxtools"
  end

  test do
    system "#{bin}/paxtools", "help"
  end
end
