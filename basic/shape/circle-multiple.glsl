precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

float saturate(float f){
    return clamp(f,0.,1.);
}

void main(){
    vec2 position=(gl_FragCoord.xy*2.-u_resolution.xy)/min(u_resolution.x,u_resolution.y);
    vec2 center=vec2(0,0);
    float radius=.3;
    const int count=6;
    float size=.01;
    float rotation=u_time;
    vec3 bgColor=vec3(0,0,0);
    
    for(int i=0;i<count;i++){
        float rad=radians(360./float(count))*float(i)-rotation;
        float ring=size/length(position-center+vec2(radius*cos(rad),radius*sin(rad)));
        float nRing=saturate(ring);
        vec3 color=vec3(1.,1.,1.)*nRing;
        
        bgColor+=color;
    }
    
    gl_FragColor=vec4(bgColor,1);
}