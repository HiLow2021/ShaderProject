precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

void main(){
    vec2 position=(gl_FragCoord.xy*2.-u_resolution.xy)/min(u_resolution.x,u_resolution.y);
    
    gl_FragColor=vec4(position.x,position.y,0.,1.);
}