precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

vec3 hsv(float h,float s,float v){
    vec4 t=vec4(1.,2./3.,1./3.,3.);
    vec3 p=abs(fract(vec3(h)+t.xyz)*6.-vec3(t.w));
    return v*mix(vec3(t.x),clamp(p-vec3(t.x),0.,1.),s);
}

void main(void){
    vec2 position=(gl_FragCoord.xy*2.-u_resolution)/min(u_resolution.x,u_resolution.y);
    
    int j=0;
    vec2 x=vec2(-.345,.654);
    vec2 y=vec2(u_time*.005,0.);
    vec2 z=position;
    for(int i=0;i<360;i++){
        j++;
        if(length(z)>2.){break;}
        z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+x+y;
    }
    
    float h=abs(mod(u_time*15.-float(j),360.)/360.);
    vec3 rgb=hsv(h,1.,1.);
    float t=float(j)/360.;
    
    gl_FragColor=vec4(rgb*t,1.);
}