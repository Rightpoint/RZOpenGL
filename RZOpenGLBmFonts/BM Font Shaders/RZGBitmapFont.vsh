//BitmapFont.vsh

attribute vec4 a_posiiton;
attribute vec2 a_texCoord;
varying vec2 v_texCoord;
uniform mat4 u_modelViewProjectionMatrix;

void main()
{
	gl_Position = u_modelViewProjectionMatrix * a_position;
	v_texCoord = a_texCoor;
}