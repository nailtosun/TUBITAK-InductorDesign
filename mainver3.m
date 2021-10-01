clear all
%% Constants
deltaT = 75; %K cupper temp. difference respect to room temp. 
alpha = 0.00393;
rho = 1.724e-8*(1+75*0.00393); %Ohm-m, copper resistivity
J = 5; % A/mm^2
%% Loss and Perm. data 
permData.name = {'14u';'26u';'40u';'60u';'75u';'90u';'125u'};
permData.a = {0.01;0.01;0.01;0.01;0.01;0.01;0.01};
permData.b = {4.938E-08; 5.266E-07; 2.177E-06; 2.142E-06; 3.885E-06;  5.830E-06; 2.209E-05};
permData.c = {2.000;1.819; 1.704; 1.855;1.819;1.819; 1.636};

lossData.name = {'14u';'26u';'40u';'60u';'75u';'90u';'125u'};
lossData.a = {80.55;52.36;52.36;44.30;44.30;44.30;44.30};
lossData.b = {1.988;1.988;1.988;1.988;1.988;1.988;1.988};
lossData.c = {1.541;1.541;1.541;1.541;1.541;1.541;1.541};

%% Load 
load('DesignData1.mat');
%% Inductor current plot
figure;
plot(t.*1e3,IL,'k');
xlabel('Time (ms)'); ylabel('$I_L$ (A)');
%%
Upplim = 30; % upper limit for design loop
NumOfCoreCandidate = 96; % No of core candidates
for i = 1:Upplim
    % Import
    f = DesignOutput(i).f;
    RipPercent = DesignOutput(i).RipplePercent;
    ILmax = DesignOutput(i).ILmax;
    ILmin = DesignOutput(i).ILmin; 
    L = DesignOutput(i).L;
    Lnum = DesignOutput(i).Lnum;
    IL = DesignOutput(i).IL;
    t = DesignOutput(i).t;
    
    IsBroken = zeros(1,NumOfCoreCandidate); % Non-volid core indicator (0: Valid, 1:NonValid)    
    for CoreID = 1:NumOfCoreCandidate
        Wa = CoreData20kW.WindowAreaWa(CoreID); %% Window Area (mm^2)
        Ac = CoreData20kW.CrosssectionAe(CoreID); %% Core Area (mm^2)

        
        % Interpolation of AL with respect to Ampere-Turn
        y1 = CoreData20kW.AL1(CoreID);
        x1 = CoreData20kW.AT1(CoreID);
        y2 = CoreData20kW.AL2(CoreID);
        x2 = CoreData20kW.AT2(CoreID);
        y3 = CoreData20kW.AL3(CoreID);
        x3 = CoreData20kW.AT3(CoreID);
        y4 = CoreData20kW.AL4(CoreID);
        x4 = CoreData20kW.AT4(CoreID);
        y5 = CoreData20kW.AL5(CoreID);
        x5 = CoreData20kW.AT5(CoreID);
        x = [x1 x2 x3 x4 x5];
        y = [y1 y2 y3 y4 y5];
        N = round(sqrt(L*1e9/y1)); % initial N
        AT = N*ILmax;
        AL_interpolated = interp1(x,y,AT);
        
        Acond = N*ILmax/J; % Conductor Area (mm)^2
        AT = N*ILmax; % Initial Ampere-Turn
        if isnan(AL_interpolated)
           IsBroken(CoreID) = 1;
           AL_interpolated = AT;
           cons = 1;
           error('');
           
        else
            cons = 0;
        end
        
        %cons = 0; % Exit condition 0: continue, 1: exit
        
        while cons == 0 % N determining loop
            
            if abs(AL_interpolated*N*N*1e-9-L) < L*10e-2 % Finish Condition
                cons = 1; % Finish Indicator
            end
            
            if AL_interpolated*N*N*1e-9 < L
                N = N + 1; 
                AT = N*ILmax;
                if AT > x5 || AT < x1 % Error Indicator (AT is out-range)
                   cons = 1; 
                   IsBroken(CoreID) = 1;
                end
                AL_interpolated = interp1(x,y,AT);
            else
                N = N - 1;
                AT = N*ILmax;
                if AT > x5 || AT < x1 % Error Indicator (AT is out-range)
                   cons = 1;
                   IsBroken(CoreID) = 1;
                end
                AL_interpolated = interp1(x,y,AT);
            end
        end
       
        Bmax = 1e6*L*ILmax/(N*Ac); %
        Bmin = 1e6*L*ILmin/(N*Ac); %
        deltaB = Bmax-Bmin;
        Acondlist(CoreID) = N*ILmax/J; % mm^2
        Ku_list(CoreID) = Acondlist(CoreID)/Wa;
        Alpercentage(CoreID) = AL_interpolated/y(1);
        Nlist(CoreID) = N;
        flist(CoreID) = f;
        Llist(CoreID) = L;
        RipPercentlist(CoreID)=RipPercent;
        % MLT interpolation
        y1 = CoreData20kW.MLT0(CoreID);
        x1 = 0;
        y2 = CoreData20kW.MLT20(CoreID);
        x2 = 0.2;
        y3 = CoreData20kW.MLT30(CoreID);
        x3 = 0.3;
        y4 = CoreData20kW.MLT40(CoreID);
        x4 = 0.4;

        y = [y1 y2 y3 y4];
        x = [x1 x2 x3 x4];
        MLT = interp1(x,y,Ku_list(CoreID));
        Rwind = N*rho*N*(MLT*1e-3)/(Acondlist(CoreID)*1e-6);
        WindingLoss(CoreID) = Lnum*Rwind*(rms(IL)^2);
        CoreLoss(CoreID) = 1e-3*Lnum*core_loss(deltaB,f./1e3,lossData,CoreID,CoreData20kW,i)*(CoreData20kW.Volume(CoreID)*1e-3);
    end
    WindingLosses(i) = {WindingLoss(intersect(find(IsBroken == 0),find(Ku_list<0.4)))};
    CoreLosses(i) = {CoreLoss(intersect(find(IsBroken == 0),find(Ku_list<0.4)))};
    CoreLossesIDs(i) = {intersect(find(IsBroken == 0),find(Ku_list<0.4))+(i-1)*NumOfCoreCandidate};
    Llistt(i) = {Llist};
    flistt(i) = {flist};
    Alpercentaget(i) = {Alpercentage};
    Ku_listt(i) = {Ku_list};
    RipPercentt(i) = {RipPercentlist};
end
%%
WindingLossAll = [];
for i=1:Upplim
    WindingLossAll = [WindingLossAll cell2mat(WindingLosses(i))];
end
%
CoreLossAll = [];
for i=1:Upplim
    CoreLossAll = [CoreLossAll cell2mat(CoreLosses(i))];
end

LListAll = [];
for i = 1:Upplim
    LListAll = [LListAll cell2mat(Llistt(i))];
end

fListAll = [];
for i = 1:Upplim
    fListAll = [fListAll cell2mat(flistt(i))];
end

AlpercentageListAll = [];
for i = 1:Upplim
    AlpercentageListAll = [AlpercentageListAll cell2mat(Alpercentaget(i))];
end


KulistAll = [];
for i = 1:Upplim
    KulistAll = [KulistAll cell2mat(Ku_listt(i))];
end

ValidIDs = [];
for i=1:Upplim
    ValidIDs = [ValidIDs cell2mat(CoreLossesIDs(i))];
end

RipPercentAll = [];
for i=1:Upplim
    RipPercentAll = [RipPercentAll cell2mat(RipPercentt(i))];
end
%%
figure
bar(ValidIDs,[WindingLossAll;CoreLossAll]','stacked');
ylabel('Losses (W)')
xlabel('Design ID'),
for k = 1:Upplim
    xline(NumOfCoreCandidate*k,'--');
end
legend('Winding Loss','Core Loss (Steinmetz)');
%%
figure;
plot(LListAll.*1e3); ylabel('L (mH)')
yyaxis right;
plot(fListAll./1e3); ylabel('f (kHz)')
