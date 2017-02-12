{ stdenv, fetchurl, lua5, postgresql, moonbridge, webmcp}:

let
  version = "3.2.2";
  frontendversion = "3.2.1";

  ldap4lqfb = fetchurl {
    url = "http://www.public-software-group.org/pub/projects/liquid_feedback/contrib/ldap4lqfb/ldap4lqfb.tar.gz";
    sha256  ="0flm2hc5jlni62y453bqrqscdc3a8qzkd4rbia39ha3ic9jd8hq8";
  };

  core = stdenv.mkDerivation {
    name = "liquidfeedback-core-${version}";

    src = fetchurl {
      url = "http://www.public-software-group.org/pub/projects/liquid_feedback/backend/v${version}/liquid_feedback_core-v${version}.tar.gz";
      sha256 = "1jy1c9y44j5abydhx1c8h03hswign9iy966xrgisxza6ji0ylz41";
    };

    buildInputs = [
      postgresql
    ];

    installPhase = ''
      mkdir -p $out/sql
      mkdir -p $out/bin
      cp core.sql $out/sql/
      cp lf_update $out/bin
      cp lf_update_issue_order $out/bin
      cp lf_update_suggestion_order $out/bin
    '';
  };

in

stdenv.mkDerivation rec {
  name = "liquidfeedback-${version}";

  src = fetchurl {
    url = "http://www.public-software-group.org/pub/projects/liquid_feedback/frontend/v${frontendversion}/liquid_feedback_frontend-v${frontendversion}.tar.gz";
    sha256 = "07mvlvis0gjv55hr5a5w2ni5cys507kv7pa2bkd0mc3b49gz6mgc";
  };

  buildInputs = [
    lua5
  ];

  installPhase = ''
    cp -r ${ldap4lqfb}/* ..

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
