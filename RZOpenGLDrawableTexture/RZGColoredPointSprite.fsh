//
//  ColorPointSprite.fsh
//  SSGOGL
//
//  Created by John Stricker on 3/9/12.
//  Copyright (c) 2012 Stricker Software. All rights reserved.
//
/*
 For solid color brush strokes with alpha set by a texture * the color uniform's alpha
 */
uniform sampler2D u_colorMap;
varying lowp vec4 v_color;

void main()
{
    gl_FragColor = v_color;
    gl_FragColor.a = texture2D(u_colorMap,gl_PointCoord).a * v_color.a;
}