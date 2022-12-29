precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;

float saturate(float f){
    return clamp(f,0.,1.);
}

void main(void){
    vec2 mousePosition=(u_mouse.xy*2.-u_resolution)/min(u_resolution.x,u_resolution.y);
    vec2 position=(gl_FragCoord.xy*2.-u_resolution)/min(u_resolution.x,u_resolution.y);
    float distance=length(mousePosition-position);
    float size=.05;
    float circle=size/distance;
    float nCircle=saturate(circle);
    vec3 color=vec3(1,1,1)*nCircle;
    
    gl_FragColor=vec4(vec3(color),1.);
}