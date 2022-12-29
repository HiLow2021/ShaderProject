precision mediump float;

uniform vec2 u_resolution;

const float PI=3.14159265;
const vec3 lightDir=vec3(-.577,.577,.577);

vec3 trans(vec3 p){
    return mod(p,4.)-2.;
}

float distanceFunc(vec3 p){
    float sphereSize=1.;
    return length(trans(p))-sphereSize;
}

vec3 getNormal(vec3 p){
    float d=.0001;
    
    return normalize(vec3(distanceFunc(p+vec3(d,0.,0.))-distanceFunc(p+vec3(-d,0.,0.)),
    distanceFunc(p+vec3(0.,d,0.))-distanceFunc(p+vec3(0.,-d,0.)),
    distanceFunc(p+vec3(0.,0.,d))-distanceFunc(p+vec3(0.,0.,-d))));
}

void main(void){
    // fragment position
    vec2 p=(gl_FragCoord.xy*2.-u_resolution)/min(u_resolution.x,u_resolution.y);
    
    // camera
    vec3 cPos=vec3(0.,0.,2.);
    float angle=60.;
    float fov=angle*.5*PI/180.;
    
    // ray
    vec3 ray=normalize(vec3(sin(fov)*p.x,sin(fov)*p.y,-cos(fov)));
    
    // marching loop
    float distance=0.;
    float rLen=0.;
    vec3 rPos=cPos;
    for(int i=0;i<64;i++){
        distance=distanceFunc(rPos);
        rLen+=distance;
        rPos=cPos+ray*rLen;
    }
    
    // hit check
    if(abs(distance)<.001){
        vec3 normal=getNormal(rPos);
        float diff=clamp(dot(lightDir,normal),.1,1.);
        gl_FragColor=vec4(vec3(diff),1.);
    }else{
        gl_FragColor=vec4(vec3(0.),1.);
    }
}