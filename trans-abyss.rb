require 'formula'

class TransAbyss < Formula
  homepage 'http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss'
  version '1.4.8'
  url 'http://www.bcgsc.ca/platform/bioinfo/software/trans-abyss/releases/1.4.8/trans-ABySS-v1.4.8_20130916.tar.gz'
  sha1 'c8f17ab737e564269784449a4feb85edd9498268'

  depends_on 'abyss'
  depends_on 'blat'
  depends_on 'bwa'
  depends_on 'gmap-gsnap'
  depends_on 'picard-tools'
  depends_on 'samtools'
  depends_on 'pysam' => :python

  def install
    abyss = Formula["abyss"].opt_prefix
    picard = Formula["picard-tools"].opt_prefix

    inreplace 'check-prereqs.sh', '``', '`' # Fix a typo
    inreplace 'setup.sh' do |s|
      s.sub! '/your/transabyss/path', libexec
      s.sub! '/your/python/path', libexec
      s.sub! '/your/abyss/path', abyss / 'bin'
      s.sub! '/your/picard/path', picard / 'share/java'
    end
    inreplace 'wrappers/trans-abyss', /^DIR=.*/,
      'DIR=' + libexec / 'wrappers'
    libexec.install Dir['*']
    bin.install_symlink '../libexec/wrappers/trans-abyss'
  end

  test do
    cd libexec do
      system './check-prereqs.sh'
    end
    system 'trans-abyss --version'
  end
end
