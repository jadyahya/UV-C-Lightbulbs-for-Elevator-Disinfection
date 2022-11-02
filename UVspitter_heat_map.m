function [d_double,d_single, maximumdosage,minimumdosage,number_of_lamps,lamps_in_x,lamps_in_y,cost] = UVspitter_heat_map(Power,price_of_bulb,time,erradicationpercentage,desiredheight,lengthofmosque,widthofmosque)
Dose=[5.6,11,15,50,220]; %corresponding to disinfection percentages [90%,99%,99.9%,99.99%,99.9999%]
%Eatonemeter is the irradiance at distance 1 meter from the lamp
%price of bulb is the price of the UVC bulb
% L is the length of the bulb
%erradication percentage could be set to 90%,99%,99.9%,99.99%,99.999%
%desired height is how high we desire to place the bulb
%dimensions of mosque at the end
%0 for heatmap and 1 for gaussian
if erradicationpercentage==90
    Dose=Dose(1); %assigning dosage from values from study/paper
elseif erradicationpercentage==99
    Dose=Dose(2); %assigning dosage from values from study/paper
elseif erradicationpercentage==99.9
    Dose=Dose(3); %assigning dosage from values from study/paper
elseif erradicationpercentage==99.99
    Dose=Dose(4); %assigning dosage from values from study/paper
elseif erradicationpercentage==99.9999
    Dose=Dose(5); %assigning dosage from values from study/paper
else 
        disp('Not a valid erradication percentage!')
    return
end
I=Dose/time; %assign value to desired minimum irradiance
r_single_max=(0.9*Power*desiredheight/(4*pi*I))^(1/3);%single lamp
r_double_max=(0.9*2*Power*desiredheight/(4*pi*I))^(1/3);%2 lamps intersection
    if r_single_max<desiredheight %impossible
        disp ('Height is not feasible, erradication percentage cannot be achieved with given paramters.')
        return
    else
        d_double=sqrt((r_double_max/sqrt(2))^2-desiredheight^2); %horizontal distance covered on the surface to be disinfected
        d_single=sqrt((r_single_max/sqrt(2))^2-desiredheight^2);% will be used for boundary lamp
        lamps_in_x=ceil(lengthofmosque/(2*d_double)); %length is the dimension in x 
        if lengthofmosque-2*(lamps_in_x-1)*d_double>2*d_single %this signifies the condition when the two boundary lamps do not meet the d requirement for a single lamp (not intersecting another lamp)
            lamps_in_x=lamps_in_x+1;
        end
        lamps_in_y=ceil(widthofmosque/(2*d_double)); %length is the dimension in x 
        if widthofmosque-2*(lamps_in_y-1)*d_double>2*d_single %this signifies the condition when the two boundary lamps do not meet the d requirement for a single lamp (not intersecting another lamp)
            lamps_in_y=lamps_in_y+1;
        end
        number_of_lamps=lamps_in_x*lamps_in_y;
        cost=number_of_lamps*price_of_bulb;
    end
    sin_angle_to_normal=desiredheight/r_single_max; %heat map for single lamp
    projection=r_single_max*cos(asin(sin_angle_to_normal));
    xmax=projection/sqrt(2);
    zmax=projection/sqrt(2);
    x=-xmax:0.01:xmax;
    z=-zmax:0.01:zmax;
    [x,z]=meshgrid(x,z);
    circular_distance=sqrt(x.^2+z.^2+desiredheight^2);
    D=1200*0.9*Power*desiredheight./(4*pi*circular_distance.^3);%irradiance array;
    surf(x,z,D)
    colorbar
    hold on
    shading interp;
    xlabel('Distance in x')
    ylabel('Distance in y')
    zlabel('Irradiance in W/m^2')
    maximumdosage=max(D,[],'all')*time;
    minimumdosage=min(D,[],'all')*time;
end
    
    