//
//  ColorPointSprite.vsh
//  SSGOGL
//
//  Created by John Stricker on 3/9/12.
//  Copyright (c) 2012 Stricker Software. All rights reserved.
//
/*
 For solid color brush strokes with alpha set by a texture * the color uniform's alpha
 */
attribute vec4 a_position;

uniform mat4 u_mvp;
uniform float u_size;
uniform lowp vec4 u_color;
varying lowp vec4 v_color;

void main()
{
    gl_Position = u_mvp * a_position;
    gl_PointSize = u_size;
    v_color = u_color;
}