#version 330

uniform mat4 matVP;
uniform mat4 matGeo;
uniform vec3 cameraPos;
uniform vec3 cameraRot;
uniform float iTime;

uniform vec3 boxPos;
uniform vec3 boxRot;
uniform vec3 boxScale;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;

out vec4 color;

mat4 translationMatrix(vec3 translateBy)
{
	return mat4(
	1., 0., 0., 0.,
	0., 1., 0., 0.,
	0., 0., 1., 0.,
	translateBy.x, translateBy.y, translateBy.z, 1.0
	);
}

mat4 rotationMatrix(vec3 rotateBy)
{
	mat4 rotateX = mat4(
	1., 0., 0., 0.,
	0., cos(rotateBy.x), -sin(rotateBy.x), 0.,
	0., sin(rotateBy.x), cos(rotateBy.x), 0.,
	0., 0., 0., 1.
	);
	mat4 rotateY = mat4(
	cos(rotateBy.y), 0., sin(rotateBy.y), 0.,
	0., 1., 0., 0.,
	-sin(rotateBy.y), 0., cos(rotateBy.y), 0.,
	0., 0., 0., 1.
	);
	mat4 rotateZ = mat4(
	cos(rotateBy.z), sin(rotateBy.z), 0., 0.,
	-sin(rotateBy.z), cos(rotateBy.z), 0., 0.,
	0., 0., 1., 0.,
	0., 0., 0., 1.
	);
	return rotateZ * rotateY * rotateX;
}

mat4 scaleMatrix(vec3 scaleBy)
{
	return mat4(
	scaleBy.x, 0., 0., 0.,
	0., scaleBy.y, 0., 0.,
	0., 0., scaleBy.z, 0.,
	0., 0., 0., 1.
	);
}

void main() {
   color = vec4(abs(normal), 1.0);
   float amount = 5;
   mat4 transformationMatrix =
     scaleMatrix(boxScale) *
     rotationMatrix(boxRot) *
     translationMatrix(boxPos);
   
   gl_Position = matVP *
     transformationMatrix *
     vec4(pos, 1);
}
