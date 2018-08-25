function eventscore = salience(pitch, vel , sal_presets)

if sal_presets ==1

    vel_factor = 0.03;
    snare_factor = 4;
    bassdrum_factor = 3;
    
elseif sal_presets ==2

    vel_factor = 0.03;
    snare_factor = 2;
    bassdrum_factor = 4;
    

else
    %flat salience
    vel_factor=0.05 ;
    snare_factor = 1 ;
    bassdrum_factor =1 ;
end

InstrumentgroupSD= [ 37, 38, 39, 40, 49, 55, 57] ;
 %                 [37= side stick, 38=acoustic snare, 39= hand clap, 40=
 %                 elec snare, 49= crash cymbal 1, 55=splash cymbal, 57= crash cymbal2]
 
 InstrumentgroupBD= [35, 36] ;
 %                  [35= acoustic BD,  36= BD1]
 
 % InstrumentgroupHH= [42, 44, 46, 51, 52, 53, 54, 56, 59, 70]
 %                  [42= closed HH, 44=pedal HH, 46=open HH, 51=Ride 1, 
 %                   52= Chinese C, 53=Ride Bell, 54= tamburine, 56= Cowbell, 59= Ride C
 %                   2, 70= Maracas]
 
 %InstrumentgroupELSE= []
 
if ismember(pitch, InstrumentgroupSD)
    if pitch==37
        vel=vel+25 ;
    end
    eventscore=snare_factor*vel_factor*vel ;


elseif ismember(pitch, InstrumentgroupBD)
    eventscore=bassdrum_factor*vel_factor*vel ;


else
    eventscore=vel_factor*vel ;
    
end

