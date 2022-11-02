z=linspace(-0.8,0.8,15);
y=linspace(0,-2.3,15);
[y,z]=meshgrid(y,z);
syms z1
d1=sqrt(0.775^2+(z+z1).^2+y.^2);
d2=sqrt(1.5^2+(z+z1).^2+y.^2);
I=(2*int(0.775*48./(4*pi*d1.^3),z1,-0.775,0.775)+int(1.55*48./(4*pi*d2.^3),z1,-0.775,0.775))/1.55;
%I=int(1.5*90./(4*pi*d2.^3),z1,-0.775,0.775)/1.55;
I=25.6*double(I);
surf(z,y,I)
colorbar
xlabel('distance in z in m')
ylabel('distance in y in m')
zlabel('Irradiance in W/m^2')
title('Dosage along walls 1 and 3 with position')
shading interp;