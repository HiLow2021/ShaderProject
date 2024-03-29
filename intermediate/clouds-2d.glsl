precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;

const float cloudscale=1.1;
const float speed=.03;
const float clouddark=.5;
const float cloudlight=.3;
const float cloudcover=.2;
const float cloudalpha=8.;
const float skytint=.5;
const vec3 skycolor1=vec3(.2,.4,.6);
const vec3 skycolor2=vec3(.4,.7,1.);

const mat2 m=mat2(1.6,1.2,-1.2,1.6);

vec2 hash(vec2 p){
    p=vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3)));
    return-1.+2.*fract(sin(p)*43758.5453123);
}

float noise(in vec2 p){
    const float K1=.366025404;// (sqrt(3)-1)/2;
    const float K2=.211324865;// (3-sqrt(3))/6;
    vec2 i=floor(p+(p.x+p.y)*K1);
    vec2 a=p-i+(i.x+i.y)*K2;
    vec2 o=(a.x>a.y)?vec2(1.,0.):vec2(0.,1.);//vec2 of = 0.5 + 0.5*vec2(sign(a.x-a.y), sign(a.y-a.x));
    vec2 b=a-o+K2;
    vec2 c=a-1.+2.*K2;
    vec3 h=max(.5-vec3(dot(a,a),dot(b,b),dot(c,c)),0.);
    vec3 n=h*h*h*h*vec3(dot(a,hash(i+0.)),dot(b,hash(i+o)),dot(c,hash(i+1.)));
    return dot(n,vec3(70.));
}

float fbm(vec2 n){
    float total=0.,amplitude=.1;
    for(int i=0;i<7;i++){
        total+=noise(n)*amplitude;
        n=m*n;
        amplitude*=.4;
    }
    return total;
}

void main(void){
    vec2 p=gl_FragCoord.xy/u_resolution.xy;
    vec2 uv=p*vec2(u_resolution.x/u_resolution.y,1.);
    float time=u_time*speed;
    float q=fbm(uv*cloudscale*.5);
    
    //ridged noise shape
    float r=0.;
    uv*=cloudscale;
    uv-=q-time;
    float weight=.8;
    for(int i=0;i<8;i++){
        r+=abs(weight*noise(uv));
        uv=m*uv+time;
        weight*=.7;
    }
    
    //noise shape
    float f=0.;
    uv=p*vec2(u_resolution.x/u_resolution.y,1.);
    uv*=cloudscale;
    uv-=q-time;
    weight=.7;
    for(int i=0;i<8;i++){
        f+=weight*noise(uv);
        uv=m*uv+time;
        weight*=.6;
    }
    
    f*=r+f;
    
    //noise color
    float c=0.;
    time=u_time*speed*2.;
    uv=p*vec2(u_resolution.x/u_resolution.y,1.);
    uv*=cloudscale*2.;
    uv-=q-time;
    weight=.4;
    for(int i=0;i<7;i++){
        c+=weight*noise(uv);
        uv=m*uv+time;
        weight*=.6;
    }
    
    //noise ridge color
    float c1=0.;
    time=u_time*speed*3.;
    uv=p*vec2(u_resolution.x/u_resolution.y,1.);
    uv*=cloudscale*3.;
    uv-=q-time;
    weight=.4;
    for(int i=0;i<7;i++){
        c1+=abs(weight*noise(uv));
        uv=m*uv+time;
        weight*=.6;
    }
    
    c+=c1;
    
    vec3 skycolor=mix(skycolor2,skycolor1,p.y);
    vec3 cloudcolor=vec3(1.1,1.1,.9)*clamp((clouddark+cloudlight*c),0.,1.);
    
    f=cloudcover+cloudalpha*f*r;
    
    vec3 result=mix(skycolor,clamp(skytint*skycolor+cloudcolor,0.,1.),clamp(f+c,0.,1.));
    
    gl_FragColor=vec4(result,1.);
}