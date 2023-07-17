#version 330

uniform vec2 resolution;
uniform float t;
in vec2 uv;
out vec4 fragColor;

struct Ray {
    vec3 origin;
    vec3 direction;
};

struct Sphere {
    vec3 position;
    float radius;
};

struct Plane {
    vec3 normal;
    float distance;
};



bool IntersectRaySphere(Ray ray, Sphere sphere, out float fraction, out vec3 normal)
{
    vec3 L = ray.origin - sphere.position;
    float a = dot(ray.direction, ray.direction);
    float b = 2.0 * dot(L, ray.direction);
    float c = dot(L, L) - sphere.radius * sphere.radius;
    float D = b * b - 4 * a * c;
    if (D < 0.0) return false;

    float r1 = (-b - sqrt(D)) / (2.0 * a);
    float r2 = (-b + sqrt(D)) / (2.0 * a);

    if (r1 > 0.0)
        fraction = r1;
    else if (r2 > 0.0)
        fraction = r2;
    else
        return false;

    normal = normalize(ray.direction * fraction + L);

    return true;
}

bool intersectPlane(Ray ray, Plane plane, out float t) {
    float denom = dot(ray.direction, plane.normal);
    
    // Проверка, чтобы избежать деления на ноль
    if (abs(denom) < 0.0001) {
        return false;
    }
    
    float t0 = (plane.distance - dot(ray.origin, plane.normal)) / denom;
    
    if (t0 < 0.0) {
        return false;
    }
    
    t = t0;
    return true;
}





void main() {
    vec3 light = vec3(-0.8, -1.2, 2);
    light.x = cos(t);
    light.z = sin(t);

    Ray ray = Ray(vec3(0), vec3(uv, 1));
    ray.direction.y *= resolution.y / resolution.x;

    Sphere sphere = Sphere(vec3(0.0, 0.0, 3.0), 1.0);
    Plane plane = Plane(vec3(0, 1, 0), -1);

    float depth = 0;
    vec3 norm = vec3(0);

    if (IntersectRaySphere(ray, sphere, depth, norm)) {
        float c = dot(norm, -light);
        fragColor = vec4(c, c, c, 1);
    }

    else if (intersectPlane(ray, plane, depth)) {
        float c = dot(plane.normal, -light);
        fragColor = vec4(c, c, c, 1);
    }

    else {
        fragColor = vec4(0, 0, 0, 1);
    }
}