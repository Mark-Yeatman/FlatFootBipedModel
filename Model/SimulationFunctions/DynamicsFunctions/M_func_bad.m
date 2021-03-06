function M = M_func(in1)
%M_FUNC
%    M = M_FUNC(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    20-Sep-2019 12:07:27

%7 Link Flat Foot with Double Support file. Only needs state as inputs, parameters are already substituted in
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
x6 = in1(6,:);
x7 = in1(7,:);
x8 = in1(8,:);
t2 = cos(x3);
t3 = cos(x4);
t4 = cos(x5);
t5 = cos(x6);
t6 = cos(x7);
t7 = cos(x8);
t8 = sin(x3);
t9 = sin(x4);
t10 = sin(x5);
t11 = sin(x6);
t12 = sin(x7);
t13 = sin(x8);
t14 = x3+x4;
t15 = x4+x5;
t16 = x5+x6;
t17 = x6+x7;
t18 = x7+x8;
t19 = t2.^2;
t20 = t8.^2;
t21 = cos(t14);
t22 = cos(t15);
t23 = cos(t16);
t24 = cos(t17);
t25 = cos(t18);
t26 = sin(t14);
t27 = sin(t15);
t28 = sin(t16);
t29 = sin(t17);
t30 = sin(t18);
t31 = t14+x5;
t32 = t15+x6;
t33 = t16+x7;
t34 = t17+x8;
t43 = t14+t16;
t44 = t15+t17;
t45 = t16+t18;
t46 = -t12;
t66 = t2.*(7.0./2.0e+2);
t67 = t8.*(7.0./2.0e+2);
t77 = t5.*(1.07e+2./1.25e+2);
t78 = t4.*(1.07e+2./2.5e+2);
t79 = t6.*(1.07e+2./2.5e+2);
t80 = t7.*(1.07e+2./2.5e+2);
t81 = t10.*(1.07e+2./2.5e+2);
t82 = t11.*(1.07e+2./2.5e+2);
t83 = t12.*(1.07e+2./2.5e+2);
t84 = t13.*(1.07e+2./2.5e+2);
t104 = t7.*1.498e-2;
t119 = t3.*2.8371e-1;
t120 = t4.*1.358044e+1;
t121 = t10.*1.358044e+1;
t124 = t6.*1.734684;
t125 = t12.*1.734684;
t133 = t4.*4.047596;
t134 = t5.*4.047596;
t135 = t5.*2.023798;
t137 = t10.*4.047596;
t138 = t11.*4.047596;
t197 = t12.*1.734684;
t217 = t5.*8.661855440000001e-1;
t222 = t3.*6.071394e-2;
t233 = t4.*6.678613864;
t238 = t6.*3.71222376e-1;
t35 = cos(t31);
t36 = cos(t32);
t37 = cos(t33);
t38 = cos(t34);
t39 = sin(t31);
t40 = sin(t32);
t41 = sin(t33);
t42 = sin(t34);
t47 = t21.^2;
t48 = t26.^2;
t49 = cos(t43);
t50 = cos(t44);
t51 = cos(t45);
t52 = sin(t43);
t53 = sin(t44);
t54 = sin(t45);
t55 = t14+t33;
t56 = t15+t34;
t61 = t18+t43;
t70 = -t66;
t71 = -t67;
t75 = t22.*(7.0./1.0e+2);
t76 = t27.*(7.0./1.0e+2);
t85 = t29+t46;
t88 = -t79;
t89 = -t80;
t90 = -t83;
t91 = -t84;
t95 = t23.*(1.07e+2./1.25e+2);
t96 = t24.*(1.07e+2./2.5e+2);
t97 = t25.*(1.07e+2./2.5e+2);
t98 = t28.*(1.07e+2./2.5e+2);
t99 = t29.*(1.07e+2./2.5e+2);
t100 = t30.*(1.07e+2./2.5e+2);
t118 = t25.*1.498e-2;
t122 = t22.*2.2211;
t123 = t27.*2.2211;
t130 = t80+7.0./2.0e+2;
t132 = -t124;
t136 = -t125;
t142 = t22.*6.6199e-1;
t143 = t24.*1.734684;
t144 = t27.*6.6199e-1;
t145 = t29.*1.734684;
t151 = t9.*t26.*2.8371e-1;
t154 = t23.*4.047596;
t155 = t23.*2.023798;
t156 = t28.*4.047596;
t166 = t9.*t21.*2.8371e-1;
t169 = t104+1.225e-3;
t174 = t120+1.358044e+1;
t178 = t119+8.67342e-1;
t179 = t124+8.67342e-1;
t182 = t133+2.023798;
t187 = t134-2.023798;
t191 = t135-1.011899;
t201 = -t197;
t212 = t29.*1.734684;
t215 = t21.*8.673419999999999e-1;
t216 = t26.*8.673419999999999e-1;
t231 = -t217;
t247 = t22.*1.09229666;
t249 = t23.*8.661855440000001e-1;
t257 = t24.*3.71222376e-1;
t267 = t12.*(t12-t29).*(-7.424447519999999e-1);
t272 = t12.*(t12-t29).*7.424447519999999e-1;
t57 = cos(t55);
t58 = cos(t56);
t59 = sin(t55);
t60 = sin(t56);
t62 = t35.^2;
t63 = t39.^2;
t64 = t49.^2;
t65 = t52.^2;
t68 = cos(t61);
t69 = sin(t61);
t86 = t36.*(7.0./5.0e+1);
t92 = t40.*(7.0./1.0e+2);
t93 = t50.*(7.0./1.0e+2);
t94 = t53.*(7.0./1.0e+2);
t101 = -t96;
t102 = -t97;
t103 = -t100;
t107 = t37.*(1.07e+2./2.5e+2);
t108 = t38.*(1.07e+2./2.5e+2);
t109 = t41.*(1.07e+2./2.5e+2);
t110 = t42.*(1.07e+2./2.5e+2);
t112 = t51.*(1.07e+2./2.5e+2);
t113 = t54.*(1.07e+2./2.5e+2);
t126 = t47.*4.053;
t128 = t48.*4.053;
t129 = t38.*1.498e-2;
t131 = t51.*1.498e-2;
t150 = t50.*2.8371e-1;
t152 = t53.*2.8371e-1;
t153 = -t143;
t159 = t36.*6.6199e-1;
t160 = t37.*1.734684;
t161 = t40.*6.6199e-1;
t162 = t41.*1.734684;
t167 = -t151;
t168 = t76+t81;
t170 = t82+t98;
t171 = t84+t100;
t175 = t75+t78+1.07e+2./2.5e+2;
t176 = t97+t130;
t177 = t75+t78+1.07e+2./5.0e+2;
t180 = t77+t95-1.07e+2./2.5e+2;
t184 = t121+t123;
t188 = t35.*t174;
t189 = t39.*t174;
t192 = t21.*t178;
t193 = t26.*t178;
t200 = t137+t144;
t206 = t118+t169;
t208 = t138+t156;
t211 = t35.*t182;
t213 = t39.*t182;
t218 = -t215;
t220 = -t216;
t224 = t49.*2.023798;
t225 = t52.*2.023798;
t226 = t49.*t187;
t227 = t52.*t187;
t229 = t35.*1.5604238e+1;
t230 = t39.*1.5604238e+1;
t236 = t36.*1.4166586e-1;
t239 = t10.*t35.*1.7628036e+1;
t241 = t11.*t49.*4.047596;
t242 = t10.*t39.*1.7628036e+1;
t244 = t11.*t52.*4.047596;
t255 = -t249;
t256 = t50.*6.071394e-2;
t260 = t122+t174;
t263 = -t257;
t265 = t37.*3.71222376e-1;
t279 = t142+t182;
t287 = t154+t187;
t288 = t155+t191;
t345 = t201+t212;
t72 = t57.^2;
t73 = t59.^2;
t74 = t69.^2;
t87 = t68.^2;
t105 = t58.*(7.0./1.0e+2);
t106 = t60.*(7.0./1.0e+2);
t111 = t69.*(7.0./2.0e+2);
t114 = -t108;
t115 = -t110;
t116 = t68.*(7.0./2.0e+2);
t117 = -t112;
t127 = t58.*2.45e-3;
t140 = -t129;
t141 = -t131;
t146 = t68.*t84;
t147 = t62.*4.1187e+1;
t148 = t69.*t84;
t149 = t63.*4.1187e+1;
t157 = t64.*9.457;
t158 = t65.*9.457;
t164 = t13.*t68.*(-1.07e+2./2.5e+2);
t172 = t68.*t130;
t173 = t69.*t130;
t181 = t79+t101+1.07e+2./5.0e+2;
t183 = t68.*t171;
t185 = t69.*t171;
t186 = t84.*t171;
t190 = t92+t170;
t195 = -t188;
t196 = -t189;
t198 = -t192;
t199 = -t193;
t202 = t35.*t168.*4.1187e+1;
t203 = t90+t99+t109;
t205 = t68.*t176;
t207 = t69.*t176;
t209 = t57.*t179;
t210 = t59.*t179;
t214 = t39.*t184;
t219 = -t211;
t221 = -t213;
t228 = t49.*t170.*9.457;
t232 = t86+t180;
t234 = -t229;
t235 = -t230;
t240 = t39.*t200;
t243 = t57.*8.673419999999999e-1;
t245 = t59.*8.673419999999999e-1;
t246 = -t226;
t248 = -t227;
t250 = -t236;
t251 = t57.*t197;
t252 = -t242;
t253 = t59.*t197;
t254 = -t244;
t259 = t12.*t57.*(-1.734684);
t261 = t52.*t208;
t262 = -t256;
t264 = t88+t96+t107-1.07e+2./5.0e+2;
t266 = t130.*t176;
t270 = -t265;
t276 = t153+t179;
t277 = t35.*t260;
t278 = t39.*t260;
t283 = t57.*(t12-t29).*(-1.734684);
t286 = t91+t103+t110+t113;
t291 = t136+t145+t162;
t292 = t35.*t279;
t293 = t39.*t279;
t294 = t161+t208;
t299 = t174.*t175;
t300 = t10.*t168.*1.7628036e+1;
t304 = t11.*t170.*4.047596;
t305 = t49.*t287;
t306 = t52.*t287;
t307 = t68.*(-t84+t103+t110+t113);
t308 = t69.*(-t84+t103+t110+t113);
t310 = t177.*t182;
t314 = t13.*(-t84+t103+t110+t113).*(1.07e+2./2.5e+2);
t317 = -t84.*(-t84+t103+t110+t113);
t324 = t180.*t191;
t326 = t132+t143+t160-8.67342e-1;
t328 = t159+t287;
t344 = t171.*(-t84+t103+t110+t113);
t362 = t59.*t345;
t139 = -t127;
t163 = t72.*4.053;
t165 = t73.*4.053;
t194 = -t183;
t204 = t115+t171;
t223 = -t214;
t237 = t114+t176;
t258 = -t240;
t271 = -t261;
t275 = t94+t203;
t282 = t49.*t190.*9.457;
t284 = -t277;
t285 = -t278;
t289 = t140+t206;
t290 = t57.*t203.*4.053;
t295 = t57.*t276;
t296 = t59.*t276;
t298 = t93+t264;
t301 = -t292;
t302 = -t293;
t311 = -t305;
t312 = -t306;
t313 = t179.*t181;
t315 = t52.*t294;
t316 = -t308;
t318 = t59.*t291;
t319 = t106+t286;
t327 = t11.*t190.*4.047596;
t330 = t89+t102+t105+t108+t112-7.0./2.0e+2;
t332 = t190.*t208;
t333 = t197.*t203;
t336 = t152+t291;
t337 = t12.*t203.*(-1.734684);
t341 = t179.*t264;
t342 = t191.*t232;
t346 = t57.*t326;
t347 = t59.*t326;
t349 = t49.*t328;
t350 = t52.*t328;
t351 = -t344;
t356 = t68.*(-t80+t102+t105+t108+t112-7.0./2.0e+2);
t357 = t69.*(-t80+t102+t105+t108+t112-7.0./2.0e+2);
t365 = t148+t172+t243;
t366 = -t362;
t368 = t164+t173+t245;
t370 = t150+t326;
t371 = t130.*(-t80+t102+t105+t108+t112-7.0./2.0e+2);
t379 = t264.*t276;
t380 = t232.*t288;
t386 = t176.*(-t80+t102+t105+t108+t112-7.0./2.0e+2);
t395 = t203.*t345;
t402 = t186+t238+t266+1.85611188e-1;
t404 = t185+t205+t209+t224+t253;
t268 = t68.*t204;
t269 = t69.*t204;
t273 = t84.*t204;
t280 = t68.*t237;
t281 = t69.*t237;
t297 = t117+t237;
t303 = t130.*t237;
t309 = t171.*t204;
t320 = -t315;
t321 = -t318;
t325 = t57.*t275.*4.053;
t329 = t176.*t237;
t331 = t141+t289;
t334 = t69.*t319;
t338 = t68.*t319;
t339 = t84.*t319;
t343 = t13.*t319.*(-1.07e+2./2.5e+2);
t348 = -t341;
t352 = -t346;
t353 = -t347;
t354 = -t349;
t355 = -t350;
t358 = t59.*t336;
t359 = -t356;
t360 = -t357;
t363 = t197.*t275;
t367 = t12.*t275.*(-1.734684);
t369 = t179.*t298;
t372 = t171.*t319;
t375 = t204.*(-t84+t103+t110+t113);
t376 = -t371;
t381 = t57.*t370;
t382 = t59.*t370;
t383 = -t379;
t388 = -t386;
t389 = t204.*t319;
t390 = t275.*t291;
t392 = t276.*t298;
t394 = t237.*(-t80+t102+t105+t108+t112-7.0./2.0e+2);
t397 = t319.*(-t84+t103+t110+t113);
t398 = t275.*t345;
t399 = t298.*t326;
t403 = t19+t20+t74+t87+t126+t128+t147+t149+t157+t158+t163+t165;
t405 = t194+t207+t210+t225+t259;
t274 = -t268;
t322 = t68.*t297;
t323 = t69.*t297;
t335 = t130.*t297;
t340 = -t334;
t361 = -t358;
t364 = t176.*t297;
t373 = t139+t331;
t374 = -t369;
t377 = -t372;
t378 = -t375;
t384 = -t381;
t385 = -t382;
t387 = t237.*t297;
t391 = -t389;
t393 = -t392;
t396 = -t394;
t400 = t297.*(-t80+t102+t105+t108+t112-7.0./2.0e+2);
t406 = t238+t263+t273+t303+1.85611188e-1;
t408 = t231+t272+t309+t313+t329+4.33092772e-1;
t410 = t234+t246+t254+t269+t280+t295+t366;
t411 = t238+t262+t263+t270+t343+t376+1.85611188e-1;
t401 = -t400;
t407 = t238+t263+t270+t317+t335+1.85611188e-1;
t409 = t235+t241+t248+t274+t281+t283+t296;
t412 = t231+t255+t337+t348+t351+t364+4.33092772e-1;
t413 = t196+t220+t221+t228+t239+t290+t307+t312+t323+t353;
t414 = t231+t250+t255+t367+t374+t377+t388+4.33092772e-1;
t415 = t195+t218+t219+t252+t271+t311+t316+t321+t322+t352;
t416 = t233+t304+t324+t378+t383+t387+t395+6.245521092;
t417 = t71+t166+t199+t202+t282+t285+t302+t325+t338+t355+t360+t385;
t418 = t233+t247+t327+t342+t391+t393+t396+t398+6.245521092;
t419 = t70+t167+t198+t223+t258+t284+t301+t320+t340+t354+t359+t361+t384;
t420 = t222+t299+t300+t310+t332+t380+t390+t397+t399+t401+1.85611188e-1;
M = reshape([t403,0.0,t419,t415,t410,t404,t365,t116,0.0,t403,t417,t413,t409,t405,t368,t111,t419,t417,(-t80+t102+t105+t108+t112-7.0./2.0e+2).^2+(t3.*(7.0./1.0e+2)+1.07e+2./5.0e+2).^2.*4.053+t9.^2.*1.98597e-2+t168.^2.*4.1187e+1+t175.^2.*3.173e+1+t177.^2.*9.457+t190.^2.*9.457+t232.^2.*2.36425+t275.^2.*4.053+t298.^2.*4.053+t319.^2+1.225e-3,t420,t418,t414,t411,t373,t415,t413,t420,(t78+1.07e+2./2.5e+2).^2.*3.173e+1+(t78+1.07e+2./5.0e+2).^2.*9.457+t10.^2.*7.544799408+t170.^2.*9.457+t180.^2.*2.36425+t203.^2.*4.053+t264.^2.*4.053+t297.^2+(-t84+t103+t110+t113).^2+1.85611188e-1,t416,t412,t407,t331,t410,t409,t418,t416,(t12-t29).^2.*7.424447519999999e-1+(t77-1.07e+2./2.5e+2).^2.*2.36425+t11.^2.*1.732371088+t181.^2.*4.053+t204.^2+t237.^2+6.245521092,t408,t406,t289,t404,t405,t414,t412,t408,(t79+1.07e+2./5.0e+2).^2.*4.053+t12.^2.*7.424447519999999e-1+t171.^2+t176.^2+4.33092772e-1,t402,t206,t365,t368,t411,t407,t406,t402,t13.^2.*1.83184e-1+t130.^2+1.85611188e-1,t169,t116,t111,t373,t331,t289,t206,t169,1.225e-3],[8,8]);
