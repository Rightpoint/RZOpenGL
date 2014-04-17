//
//  RZGModelDefaultShader.fsh
//
//  Created by John Stricker on 4/17/14
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//
/*
 Default fragment shader with a single hard coded light
 */

precision mediump float;
varying highp vec4 v_colorVarying;
varying vec2 v_texCoord;
uniform sampler2D u_colorMap;
uniform float u_alpha;
void main()
{
    gl_FragColor = texture2D(u_colorMap,v_texCoord) * v_colorVarying;
    gl_FragColor.rgba *=u_alpha;
}