class Rate4site < Formula
  desc "Compute site-specific evolutionary rates for an amino-acid sequence"
  homepage "https://www.tau.ac.il/~itaymay/cp/rate4site.html"
  url "ftp://rostlab.org/rate4site/rate4site-3.0.0.tar.gz"
  sha256 "5f748131bc2d10383c35c3141a835efa4ec1e7088cd9d8970e8024021aa509ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "272159ce705abd98674ff30051b7221da34580a55b1d8045849dfc1035576f92" => :el_capitan
    sha256 "cde872f77a3cf3c808a813129e9c7da4f72eba1c167fc0fe6c7405c01172e65d" => :yosemite
    sha256 "872e77f6f52c47466204ff0c5931c926208793a0f4e1a7a7e52f3c6bdd1dbe84" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"seq.aln").write <<-EOS.undent
      CLUSTAL V


      Horse            KVFSKCELAHKLKAQEMDGFGGYSLANWVCMAEYESNFNTRAFNGKNANGSSDYGLFQLN
      Langur           KIFERCELARTLKKLGLDGYKGVSLANWVCLAKWESGYNTEATNYNPGDESTDYGIFQIN
      Human            KVFERCELARTLKRLGMDGYRGISLANWMCLAKWESGYNTRATNYNAGDRSTDYGIFQIN
      Rat              KTYERCEFARTLKRNGMSGYYGVSLADWVCLAQHESNYNTQARNYDPGDQSTDYGIFQIN
      Cow              KVFERCELARTLKKLGLDGYKGVSLANWLCLTKWESSYNTKATNYNPSSESTDYGIFQIN
      Baboon           KIFERCELARTLKRLGLDGYRGISLANWVCLAKWESDYNTQATNYNPGDQSTDYGIFQIN


      Horse            NKWWCKDNKRSSSNACNIMCSKLLDENIDDDISCAKRVVRDKGMSAWKAWVKHCKDKDLS
      Langur           SRYWCNNGKPGAVDACHISCSALLQNNIADAVACAKRVVSDQGIRAWVAWRNHCQNKDVS
      Human            SRYWCNDGKPGAVNACHLSCSALLQDNIADAVACAKRVVRDQGIRAWVAWRNRCQNRDVR
      Rat              SRYWCNDGKPRAKNACGIPCSALLQDDITQAIQCAKRVVRDQGIRAWVAWQRHCKNRDLS
      Cow              SKWWCNDGKPNAVDGCHVSCSELMENDIAKAVACAKKIVSEQGITAWVAWKSHCRDHDVS
      Baboon           SHYWCNDGKPGAVNACHISCNALLQDNITDAVACAKRVVSDQGIRAWVAWRNHCQNRDVS


      Horse            EYLASCNL
      Langur           QYVKGCGV
      Human            QYVQGCGV
      Rat              GYIRNCGV
      Cow              SYVEGCTL
      Baboon           QYVQGCGV
      EOS
    system "#{bin}/rate4site", "-s", "seq.aln"
  end
end
