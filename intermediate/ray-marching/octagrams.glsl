precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;

const float REPEAT=5.;

// 回転行列
mat2 rot(float a){
	float c=cos(a),s=sin(a);
	return mat2(c,s,-s,c);
}

float sdBox(vec3 p,vec3 b)
{
	vec3 q=abs(p)-b;
	return length(max(q,0.))+min(max(q.x,max(q.y,q.z)),0.);
}

float box(vec3 pos,float scale){
	pos*=scale;
	float base=sdBox(pos,vec3(.4,.4,.1))/1.5;
	pos.xy*=5.;
	pos.y-=3.5;
	pos.xy*=rot(.75);
	float result=-base;
	return result;
}

float box_set(vec3 pos,float iTime){
	vec3 pos_origin=pos;
	pos=pos_origin;
	pos.y+=sin(iTime*.4)*2.5;
	pos.xy*=rot(.8);
	float box1=box(pos,2.-abs(sin(iTime*.4))*1.5);
	pos=pos_origin;
	pos.y-=sin(iTime*.4)*2.5;
	pos.xy*=rot(.8);
	float box2=box(pos,2.-abs(sin(iTime*.4))*1.5);
	pos=pos_origin;
	pos.x+=sin(iTime*.4)*2.5;
	pos.xy*=rot(.8);
	float box3=box(pos,2.-abs(sin(iTime*.4))*1.5);
	pos=pos_origin;
	pos.x-=sin(iTime*.4)*2.5;
	pos.xy*=rot(.8);
	float box4=box(pos,2.-abs(sin(iTime*.4))*1.5);
	pos=pos_origin;
	pos.xy*=rot(.8);
	float box5=box(pos,.5)*6.;
	pos=pos_origin;
	float box6=box(pos,.5)*6.;
	float result=max(max(max(max(max(box1,box2),box3),box4),box5),box6);
	return result;
}

float map(vec3 pos,float iTime){
	vec3 pos_origin=pos;
	float box_set1=box_set(pos,iTime);
	
	return box_set1;
}

void main(void){
	vec2 p=(gl_FragCoord.xy*2.-u_resolution.xy)/min(u_resolution.x,u_resolution.y);
	vec3 ro=vec3(0.,-.2,u_time*4.);
	vec3 ray=normalize(vec3(p,1.5));
	ray.xy=ray.xy*rot(sin(u_time*.03)*5.);
	ray.yz=ray.yz*rot(sin(u_time*.05)*.2);
	float t=.1;
	vec3 col=vec3(0.);
	float ac=0.;
	
	for(int i=0;i<99;i++){
		vec3 pos=ro+ray*t;
		pos=mod(pos-2.,4.)-2.;
		float gTime=u_time-float(i)*.01;
		
		float d=map(pos,gTime);
		
		d=max(abs(d),.01);
		ac+=exp(-d*23.);
		
		t+=d*.55;
	}
	
	col=vec3(ac*.02);
	col+=vec3(0.,.2*abs(sin(u_time)),.5+sin(u_time)*.2);
	
	gl_FragColor=vec4(col,1.-t*(.02+.02*sin(u_time)));
}