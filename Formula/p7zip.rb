class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "https://p7zip.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2"
  sha256 "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f"
  # CPP/7zip/Compress/Rar* files:  GNU LGPL + unRAR restriction
  license "LGPL-2.1"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ecdc4815bfff50521a58b16dd8e5433734353361a0a25fe2f1a56aa8c102a567" => :big_sur
    sha256 "b9f5fb1321ce5738d0129b3c48f51fc36a947bd84450f95ce9caa90e767fbd1b" => :catalina
    sha256 "0de20c4bd05dc5652ca5f188895bf74e52eb701aaed502a0d1271eb58236f898" => :mojave
    sha256 "5951a42bd864da7dba5ef5781a2efba206daba8b6f75c60c0cfd910dae218482" => :high_sierra
    sha256 "73fe6276e906f67cd28adc0f5a22c914d57fd3cfdd54134ad64e5330f710235a" => :sierra
    sha256 "fc22088a7e64d75874c4f0b69981e1b56ca62d3a2f1fb170275cbf0985be9e95" => :x86_64_linux
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/p/p7zip/p7zip_16.02+dfsg-6.debian.tar.xz"
    sha256 "fab0be1764efdbde1804072f1daa833de4e11ea65f718ad141a592404162643c"
    apply "patches/12-CVE-2016-9296.patch",
          "patches/13-CVE-2017-17969.patch"
  end

  patch :p4 do
    url "https://github.com/aonez/Keka/files/2940620/15-Enhanced-encryption-strength.patch.zip"
    sha256 "838dd2175c3112dc34193e99b8414d1dc1b2b20b861bdde0df2b32dbf59d1ce4"
  end

  def install
    if OS.mac?
      mv "makefile.macosx_llvm_64bits", "makefile.machine"
    else
      mv "makefile.linux_any_cpu", "makefile.machine"
    end
    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end
