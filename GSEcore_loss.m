function y = GSEcore_loss(B,f,lossData,CoreID,CoreData20kW,t,IL,L,N,Ac,i)
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

    if i <= 60
        T = t(end);
    else
        T = t(end);
    end

    if i <= 60
        B = 1e4*L*IL/(N*Ac);
        y = 4*CoreData20kW.Volume(CoreID)*1e-9*sum(a*(abs((diff(B)./diff(t))).^c).*B(1:end-1).^(b-c))*(t(2)-t(1))/T;
    else
        B = 1e4*L*IL/(N*Ac);
        y = CoreData20kW.Volume(CoreID)*1e-9*sum(a*(abs((diff(B)./diff(t))).^c).*B(1:end-1).^(b-c))*(t(2)-t(1))/T;
    end

end