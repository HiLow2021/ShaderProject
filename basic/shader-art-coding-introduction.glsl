/* This animation is the material of my first youtube tutorial about creative
coding, which is a video in which I try to introduce programmers to GLSL
and to the wonderful world of shaders, while also trying to share my recent
passion for this community.
Video URL: https://youtu.be/f4s1h2YETNY
*/
precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;

//https://iquilezles.org/articles/palettes/
vec3 palette(float t){
    vec3 a=vec3(.5,.5,.5);
    vec3 b=vec3(.5,.5,.5);
    vec3 c=vec3(1.,1.,1.);
    vec3 d=vec3(.263,.416,.557);
    
    return a+b*cos(6.28318*(c*t+d));
}

//https://www.shadertoy.com/view/mtyGWy
void main(void){
    vec2 uv=(gl_FragCoord.xy*2.-u_resolution.xy)/u_resolution.y;
    vec2 uv0=uv;
    vec3 finalColor=vec3(0.);
    
    for(float i=0.;i<4.;i++){
        uv=fract(uv*1.5)-.5;
        
        float d=length(uv)*exp(-length(uv0));
        
        vec3 col=palette(length(uv0)+i*.4+u_time*.4);
        
        d=sin(d*8.+u_time)/8.;
        d=abs(d);
        
        d=pow(.01/d,1.2);
        
        finalColor+=col*d;
    }
    
    gl_FragColor=vec4(finalColor,1.);
}