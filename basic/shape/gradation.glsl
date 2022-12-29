precision mediump float;

uniform vec2 u_resolution;

float saturate(float f){
    return clamp(f,0.,1.);
}

void main(){
    vec2 position=(gl_FragCoord.xy*2.-u_resolution.xy)/min(u_resolution.x,u_resolution.y);
    float gradation=dot(position,vec2(0,1));
    vec3 color=vec3(1.,1.,1.)*gradation;
    
    gl_FragColor=vec4(color,1);
}