{ stdenv, fetchurl, lua5, postgresql, moonbridge, webmcp}:

stdenv.mkDerivation rec {
  version  ="3.2.2";
  frontendversion = "3.2.1";

  name = "liquidfeedback-${version}";

  core = fetchurl {
      url = "http://www.public-software-group.org/pub/projects/liquid_feedback/backend/v${version}/liquid_feedback_core-v${version}.tar.gz";
      sha256 = "1jy1c9y44j5abydhx1c8h03hswign9iy966xrgisxza6ji0ylz41";
  };

  frontend = fetchurl {
      url = "http://www.public-software-group.org/pub/projects/liquid_feedback/frontend/v${frontendversion}/liquid_feedback_frontend-v${frontendversion}.tar.gz";
      sha256 = "07mvlvis0gjv55hr5a5w2ni5cys507kv7pa2bkd0mc3b49gz6mgc";
  };

  ldap4lqfb = fetchurl {
      url = "http://www.public-software-group.org/pub/projects/liquid_feedback/contrib/ldap4lqfb/ldap4lqfb.tar.gz";
      sha256  ="0flm2hc5jlni62y453bqrqscdc3a8qzkd4rbia39ha3ic9jd8hq8";
  };

  srcs = [ core frontend ldap4lqfb];

  buildInputs = [
   lua5 postgresql
  ];

  sourceRoot = ".";

  preBuild = ''
     cd ${sourceRoot}/liquid_feedback_core-v${version}
     make
  '';

  installPhase = ''
	mkdir -p $out/core/sql
	mkdir -p $out/core/bin
	cp $sourceRoot/liquid_feedback_core-v${version}/core.sql $out/core/sql/
    cp $sourceRoot/liquid_feedback_core-v${version}/lf_update $out/core/bin
    cp $sourceRoot/liquid_feedback_core-v${version}/lf_update_issue_order $out/core/bin
    cp $sourceRoot/liquid_feedback_core-v${version}/lf_update_suggestion_order $out/core/bin/

    mkdir -p $out/frontend
    cp -r $out/liquid_feedback_frontend-v${frontendversion} $out/frontend/    

  '';

  meta = with stdenv.lib; {
    description = "LiquidFeedback is an open-source software, powering internet platforms for proposition development and decision making.";
    homepage = "http://www.public-software-group.org/liquid_feedback";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ruebenix ];
  };
}
