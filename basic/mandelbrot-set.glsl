precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

// HSV カラー生成関数
vec3 hsv(float h,float s,float v){
    vec4 t=vec4(1.,2./3.,1./3.,3.);
    vec3 p=abs(fract(vec3(h)+t.xyz)*6.-vec3(t.w));
    return v*mix(vec3(t.x),clamp(p-vec3(t.x),0.,1.),s);
}

void main(void){
    // フラグメント座標の正規化
    vec2 position=(gl_FragCoord.xy*2.-u_resolution)/min(u_resolution.x,u_resolution.y);
    
    // マンデルブロ集合
    int j=0;// カウンタ
    vec2 x=position+vec2(-.5,0.);// 原点を少しずらす
    vec2 z=vec2(0.,0.);// 漸化式 Z の初期値
    
    // 漸化式の繰り返し処理(今回は 360 回ループ)
    for(int i=0;i<360;i++){
        j++;
        if(length(z)>2.){break;}
        z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+x;
    }
    
    // 時間の経過で色を HSV 出力する
    float h=mod(u_time*20.,360.)/360.;
    vec3 rgb=hsv(h,1.,1.);
    
    // 漸化式で繰り返した回数をもとに輝度を決める
    float t=float(j)/360.;
    
    // 最終的な色の出力
    gl_FragColor=vec4(rgb*t,1.);
    
}