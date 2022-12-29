precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

float saturate(float f){
    return clamp(f,0.,1.);
}

void main(){
    vec2 position=(gl_FragCoord.xy*2.-u_resolution.xy)/min(u_resolution.x,u_resolution.y);
    vec2 center=vec2(0,0);
    float count=10.;
    float rotation=u_time;
    float radiation=sin(atan(position.y-center.y,position.x-center.x)*count+rotation);
    float nRadiation=saturate(radiation);
    vec3 color=vec3(1,1,1)*nRadiation;
    
    gl_FragColor=vec4(color,1);
}