// BitmapFont.fsh

precision mediump float;
varying vec2 v_texCoord;
uniform sampler2D u_colorMap;
uniform float u_alpha;

void main()
{
	gl_FragColor = texture2D(u_colorMap,v_texCoord);
	gl_FragColor.rgba *= u_alpha;	
}