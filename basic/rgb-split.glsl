precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture_0;

float g_indensity=.01;

float random(float x,float y){
    return fract(sin(dot(vec2(x,y),vec2(12.9898,78.233)))*43758.5453);
}

void main(){
    vec2 uv=gl_FragCoord.xy/u_resolution.xy;
    
    float splitAmount=g_indensity*random(u_time,2.);
    
    vec4 colorR=texture2D(u_texture_0,vec2(uv.x+splitAmount,uv.y));
    vec4 colorG=texture2D(u_texture_0,uv);
    vec4 colorB=texture2D(u_texture_0,vec2(uv.x-splitAmount,uv.y));
    
    gl_FragColor=vec4(colorR.r,colorG.g,colorB.b,1.);
}