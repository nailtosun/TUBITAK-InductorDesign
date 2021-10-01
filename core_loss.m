function y = core_loss(B,f,lossData,CoreID,CoreData20kW,i)
if CoreData20kW.mu_r(CoreID) == 14
    ind = 1;
elseif CoreData20kW.mu_r(CoreID) == 26
    ind = 2;
elseif CoreData20kW.mu_r(CoreID) == 40
    ind = 3;
elseif CoreData20kW.mu_r(CoreID) == 60
    ind = 4;
elseif CoreData20kW.mu_r(CoreID) == 75
    ind = 5;
elseif CoreData20kW.mu_r(CoreID) == 90
    ind = 6;
else 
    ind = 7;
end
a = cell2mat(lossData.a(ind));
b = cell2mat(lossData.b(ind));
c = cell2mat(lossData.c(ind));

y = a*(B^b)*(2*f)^c; % mW/cm^3
end