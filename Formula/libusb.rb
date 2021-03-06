class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.24/libusb-1.0.24.tar.bz2"
  sha256 "7efd2685f7b327326dcfb85cee426d9b871fd70e22caa15bb68d595ce2a2b12a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "74e0067e968ddbea31e070885ae86bc1db5c66fd157588e84576e653e62894c8" => :big_sur
    sha256 "034ae259f17afb5894860cdb1786fd6d391359e8d221c0f765eceed6210b60df" => :catalina
    sha256 "1318e1155192bdaf7d159562849ee8f73cb0f59b0cb77c142f8be99056ba9d9e" => :mojave
    sha256 "b6c5e81cb430546009410949485f379a1dfd1c4201abe90d04f7698a98e977f0" => :x86_64_linux
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "systemd" if OS.linux? # for libudev

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*"] - Dir["examples/Makefile*"]
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "-L#{lib}", "-I#{include}/libusb-1.0",
             "listdevs.c", "-o", "test", "-lusb-1.0"
      system "./test"
    end
  end
end
