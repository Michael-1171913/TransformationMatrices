#version 330

uniform mat4 matVP;
uniform vec3 cameraPos;
uniform vec3 cameraRot;
uniform float iTime;

uniform vec3 boxPos;
uniform vec3 boxRot;
uniform vec3 boxScale;

uniform vec3 cameraPosition;

uniform bool isPerspectiveProjection;
uniform vec4 LeftRightTopBottom;
uniform vec2 NearFar;

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

mat4 lookatMatrix()
{
	// point of interest
	vec3 p = vec3(0.f, 0.f, 0.f);
	// up vector
	vec3 u = vec3(0.f, 1.f, 0.f);
	// eye
	vec3 e = cameraPosition;

	// forward vector
	vec3 f = (p - e)/(abs(p-e));
	
	vec3 s = f * u;
	vec3 uPrime = s * f;
	
	return mat4(
	s.x, s.y, s.z, 0.f,
	uPrime.x, uPrime.y, uPrime.z, 0.f,
	f.x, f.y, f.z, 0.f,
	-e.x, -e.y, -e.z, 1.f
	);
}

mat4 projectionMatrix()
{
	float left = LeftRightTopBottom[0];
	float right = LeftRightTopBottom[1];
	float top = LeftRightTopBottom[2];
	float bottom = LeftRightTopBottom[3];
	float near = NearFar[0];
	float far = NearFar[1];
	
	return mat4(
	(2*near)/(right-left), 0.f, 0.f, 0.f,
	0.f, (2*near)/(top-bottom), 0.f, 0.f,
	(right+left)/(right-left), (top+bottom)/(top-bottom), (near+far)/(near-far), -1.f,
	0.f, 0.f, (2*near*far)/(near-far), 0.f
	);
}

mat4 orthographicMatrix()
{
	float left = LeftRightTopBottom[0];
	float right = LeftRightTopBottom[1];
	float top = LeftRightTopBottom[2];
	float bottom = LeftRightTopBottom[3];
	float near = NearFar[0];
	float far = NearFar[1];
	
	return mat4(
	2/(right-left), 0.f, 0.f, 0.f,
	0.f, 2/(top-bottom), 0.f, 0.f,
	0.f, 0.f, 2/(near-far), 0.f,
	(left+right)/(left-right), (bottom+top)/(bottom-top), (near+far)/(near-far), 1.f
	);
}

void main() {
   color = vec4(abs(normal), 1.0);
   float amount = 5;
   mat4 transformationMatrix =
     scaleMatrix(boxScale) *
     rotationMatrix(boxRot) *
     translationMatrix(boxPos);
  
   //transformationMatrix *= lookatMatrix();
  
   mat4 perspectiveMatrix = isPerspectiveProjection ? projectionMatrix() : orthographicMatrix();
  
   gl_Position = perspectiveMatrix *
     transformationMatrix *
     vec4(pos, 1);
}
