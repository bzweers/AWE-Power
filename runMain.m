% Performance model
clc
clearvars
clear global

global outputs
 
% inputSheet_AP3;
% inputSheet_softKite;
inputSheet;

% Compute for every wind speed
for i=1:length(inputs.Vw)
  
  % Optimisation problem setup
  x_init = [150, 20, inputs.Tmax, 1.5]; %[deltaL, VRI, Tmax, CL]
  x0     = x_init./x_init;
  lb     = [50, 5, inputs.Tmax, inputs.CL0_airfoil]./x_init;
  ub     = [300, inputs.maxVRI, inputs.Tmax, inputs.CL_maxAirfoil]./x_init;
  
  options                           = optimoptions('fmincon');
  options.Display                   = 'iter-detailed';
  options.Algorithm                 = 'sqp';
   options.FiniteDifferenceType     = 'central';
%   options.OutputFcn                = @O_outfun;
%  options.FiniteDifferenceStepSize = 1e-10;
%   options.MaxFunctionEvaluations   = 1000*numel(X_init);
%   options.ConstraintTolerance      = 0;
  options.OptimalityTolerance      = 1e-15;
%   options.FunctionTolerance        = 1e-4;
%  options.StepTolerance            = 1e-14;
%   options.DiffMaxChange            = 1e-1;
%   options.DiffMinChange            = 1e-2;
%   options.MaxIterations            = 3;
%   options.PlotFcns                 = {@optimplotfval, @optimplotx, @optimplotfirstorderopt,...
%                                @optimplotconstrviolation, @optimplotfunccount, @optimplotstepsize};

  con = @(x) constraints(i,inputs);
  
  [x,fval,~] = fmincon(@(x) objective(x,x_init,i,inputs),x0,[],[],[],[],lb,ub,con,options);
  
  % Storing final results
   [~,inputs,outputs] = objective(x,x_init,i,inputs);
   x_output = x.*x_init;
 
end

%% Post processing
Vw = inputs.Vw;

% Cut-in wind speed
%temp = Vw(outputs.P_cycleElec>0);
% The velocity of the kite cannot be negative while flying patterns
temp         = Vw((outputs.VC-outputs.VC_osciAmp)>0);
system.cutIn = temp(1);

% Rated wind speed and power
temp = find((inputs.P_ratedElec - outputs.P_cycleElec)<0.1);
if isempty(temp)
  system.ratedWind  = Vw(outputs.P_cycleElec==max(outputs.P_cycleElec));
else
  system.ratedWind  = Vw(temp(1));
end
system.ratedPower = max(outputs.P_cycleElec);

% System data
system.VRO_osci         = zeros(length(Vw),length(outputs.VRO_osci(1,:)));
system.PROeff_mech_osci = zeros(length(Vw),length(outputs.VRO_osci(1,:)));
system.PROeff_elec_osci = zeros(length(Vw),length(outputs.VRO_osci(1,:)));
system.D_te             = outputs.D_te;
system.numPattParts     = outputs.numPattParts;
for i=1:length(Vw)
    if Vw(i)<system.cutIn
        system.PRO1_mech(i)    = 0;
        system.PRI2_mech(i)    = 0; 
        system.PROeff_mech(i)  = 0;
        system.PRIeff_mech(i)  = 0;  
        system.PRO1_elec(i)    = 0;
        system.PRI2_elec(i)    = 0; 
        system.PROeff_elec(i)  = 0;
        system.PRIeff_elec(i)  = 0;
        system.PRO_mech(i)    = 0;
        system.PRI_mech(i)    = 0;
        system.PRO_elec(i)    = 0;
        system.PRI_elec(i)    = 0;
        system.deltaL(i)      = 0;
        system.t1(i)          = 0;
        system.t2(i)          = 0;
        system.tROeff(i)      = 0;
        system.tRIeff(i)      = 0;
        system.tRO(i)         = 0;
        system.tRI(i)         = 0;
        system.TT(i)          = 0;
        system.VRO(i)         = 0;
        system.VRI(i)         = 0;
        system.Pcycle_elec(i) = 0;
        system.Pcycle_mech(i) = 0;
        system.VRO_osci(i,:)       = 0;
        system.PROeff_mech_osci(i,:)  = 0;
        system.PROeff_elec_osci(i,:)  = 0;
        system.pattRadius(i)       = 0;
        system.H_avg(i)            = 0;
        system.rollAngle(i)        = 0;
        system.CL(i)               = 0;
        system.CD(i)               = 0;
    else
        system.PRO1_mech(i)    = outputs.PRO1_mech(i);
        system.PRI2_mech(i)    = outputs.PRI2_mech(i); 
        system.PROeff_mech(i)  = outputs.PROeff_mech(i);
        system.PRIeff_mech(i)  = outputs.PRIeff_mech(i);  
        system.PRO1_elec(i)    = outputs.PRO1_elec(i);
        system.PRI2_elec(i)    = outputs.PRI2_elec(i); 
        system.PROeff_elec(i)  = outputs.PROeff_elec(i);
        system.PRIeff_elec(i)  = outputs.PRIeff_elec(i);
        system.PRO_mech(i)    = outputs.PRO_mech(i);
        system.PRI_mech(i)    = outputs.PRI_mech(i);
        system.PRO_elec(i)    = outputs.PRO_elec(i);
        system.PRI_elec(i)    = outputs.PRI_elec(i);
        system.deltaL(i)      = outputs.deltaL(i);
        system.t1(i)          = outputs.t1(i);
        system.t2(i)          = outputs.t2(i);
        system.tROeff(i)      = outputs.tROeff(i);
        system.tRIeff(i)      = outputs.tRIeff(i);
        system.tRO(i)         = outputs.tRO(i);
        system.tRI(i)         = outputs.tRI(i);
        system.TT(i)          = outputs.T(i);
        system.VRO(i)         = outputs.VRO(i);
        system.VRI(i)         = outputs.VRI(i);
        system.Pcycle_elec(i) = outputs.P_cycleElec(i);
        system.Pcycle_mech(i) = outputs.P_cycleMech(i);
        system.VRO_osci(i,:)  = outputs.VRO_osci(i,:);
        system.PROeff_mech_osci(i,:)  = outputs.PROeff_mech_osci(i,:);
        system.PROeff_elec_osci(i,:)  = outputs.PROeff_elec_osci(i,:);
        system.pattRadius(i)    = outputs.pattRadius(i);
        system.H_avg(i)      = outputs.H_avg(i);
        system.rollAngle(i)  = rad2deg(outputs.rollAngle(i));
        system.CL(i)         = outputs.CL(i);
        system.CD(i)         = outputs.CD(i);
    end
    system.tCycle(i)    = system.tRO(i)+system.tRI(i);  
    system.dutyCycle(i) = system.tRO(i)/system.tCycle(i);
    system.tPatt(i)     = 0;
    for j = 1:outputs.numPattParts
      system.tPatt(i)  = system.tPatt(i) + 2*pi()*system.pattRadius(i)/outputs.numPattParts/outputs.VC_osci(i,j);
    end 
    system.osciFactor(i,:) = outputs.osciFactor(i,:);
    system.numOfPatt(i) = system.tRO(i)/system.tPatt(i);
    system.reelOutF(i)  = system.VRO(i)/Vw(i); 
end

% Instantaneous cycle data
timeseries = struct();
for i = system.cutIn:length(Vw)
  [timeseries.ws(i)] = createTimeseries(i,system);
end

%% Plots

%% Plot oscillating VRO and PRO_mech
i = [system.ratedWind,21, 22, 25];
d.series1 = system.PROeff_elec_osci(i(1),:)/10^3;  
d.series2 = system.PROeff_elec_osci(i(2),:)/10^3; 
d.series3 = system.PROeff_elec_osci(i(3),:)/10^3; 
d.series4 = system.PROeff_elec_osci(i(4),:)/10^3; 

figure('units','inch','Position', [5 5 3.5 2.2])
hold on
grid on
box on
plot(d.series1,'linewidth',1.2);
plot(d.series2,'linewidth',1.2);
plot(d.series3,'linewidth',1.2);
plot(d.series4,'linewidth',1.2);
ylabel('Electrical capped power (kW)');
%ylim([30 100]);
legend(strcat(num2str(i(1)),'m/s'),strcat(num2str(i(2)),'m/s'),strcat(num2str(i(3)),'m/s'),strcat(num2str(i(4)),'m/s'),'location','southeast');
xlabel('Positions in a single pattern');
%xlim([0 25]);
hold off

%% Cycle timeseries plots, Check reel-in representation: Time and power in each regime should add to total reel-in energy
windSpeeds = [21];

for i = windSpeeds
  tmax = round(max(system.tCycle(windSpeeds)));
  pmax = 1.2*inputs.F_peakElecP*max(system.Pcycle_elec(windSpeeds))/10^3;
  pmin = min(-system.PRIeff_elec(windSpeeds))/10^3;
  
  figure('units','inch','Position', [5 5 3.5 2.2])
  hold on
  grid on
  box on
  yline(0);
  yline(system.Pcycle_elec(timeseries.ws(i).ws)/10^3,'--');
  plot(timeseries.ws(i).t_inst, timeseries.ws(i).P_inst,'linewidth',1.5);
  ylabel('Electrical power (kW)');
  xlabel('Time (s)');
  xlim([0 tmax]);
  ylim([pmin pmax]);
  title(strcat('Wind speed:',num2str(timeseries.ws(i).ws),'m/s'));
  legend('','Cycle average','Instantaneous','location','northwest');
  hold off
end

%% TT,VRO,VRI plot

figure('units','inch','Position', [5 5 3.5 2.2])
hold on
grid on
box on
yyaxis left
plot(Vw, system.TT./10^3,'x','markersize',4);
ylabel('Tether tension (kN)');
ylim([0 1.1*max(system.TT)/10^3]);
yyaxis right
plot(Vw, system.VRO,'+','markersize',3);
plot(Vw, system.VRI,'o','markersize',3);
legend('T','V_{RO}','V_{RI}','location','southeast');
xlabel('Wind speed at avg. pattern altitude (m/s)');
ylabel('Speed (m/s)');
xlim([0 25]);
ylim([0 1.05*inputs.maxVRI]);
hold off


% DeltaL, cycle times
figure('units','inch','Position', [5 5 3.5 2.2])
hold on
grid on
box on
yyaxis left
plot(Vw, system.deltaL,'x','markersize',4);
ylabel('Length (m)');
yyaxis right
plot(Vw, system.tRO,'+','markersize',3);
plot(Vw, system.tRI,'o','markersize',3);
ylabel('Time(s)');
legend('ΔL','t_{RO}','t_{RI}','location','northwest');
xlabel('Wind speed at avg. pattern altitude (m/s)');
xlim([0 25]);
%ylim([0 160]);
hold off

% H_avg, patt radius, Avg tether length
figure('units','inch','Position', [5 5 3.5 2.2])
hold on
grid on
box on
plot(Vw, system.H_avg,'^','markersize',3);
plot(Vw, system.pattRadius,'x','markersize',4);
plot(Vw, outputs.L_teAvg,'o','markersize',3);
ylabel('Length (m)');
legend('H_{avg}','R_{patt}','L_{tether,avg}','location','northwest');
xlabel('Wind speed at avg. pattern altitude (m/s)');
xlim([0 25]);
%ylim([0 160]);
hold off

% Dimension less nos: CL,CD,reel-out factor
figure('units','inch','Position', [5 5 3.5 2.2])
hold on
grid on
box on
plot(Vw, system.CL,'^','markersize',3);
plot(Vw, system.CD,'x','markersize',4);
plot(Vw, system.reelOutF,'o','markersize',3);
ylabel('Length (m)');
legend('C_{L}','C_{D}','Reel-out factor','location','northwest');
xlabel('Wind speed at avg. pattern altitude (m/s)');
xlim([0 25]);
%ylim([0 160]);
hold off



% Cycle efficiencies
ERO_elec = system.PROeff_elec.*system.tROeff + system.PRO1_elec.*system.t1;
ERI_elec = system.PRIeff_elec.*system.tRIeff + system.PRI2_elec.*system.t2;
ERO_mech = system.PROeff_mech.*system.tROeff + system.PRO1_mech.*system.t1;
ERI_mech = system.PRIeff_mech.*system.tRIeff + system.PRI2_mech.*system.t2;

figure('units','inch','Position', [5 5 3.5 2.2])
hold on
grid on
box on
yyaxis left
plot(Vw, system.Pcycle_elec./10^3,'-','linewidth',1.2);
ylabel('Power (kW)');
ylim([0 1.1*system.ratedPower/10^3]);
yyaxis right
plot(Vw, (ERO_mech-ERI_mech)./ERO_mech*100,'+','markersize',3);
plot(Vw, (ERO_elec-ERI_elec)./ERO_mech*100,'o','markersize',3);
% plot(Vw, system.Pcycle_mech./system.PRO_mech*100,'x','markersize',4);
% plot(Vw, (ERO_elec-ERI_elec)./(ERO_mech-ERI_mech)*100,'o','markersize',3);
% plot(Vw, system.dutyCycle*100,'x','markersize',3);
ylabel('Efficiency (%)');
ylim([30 100]);
legend('P_{cycle,elec}','η_{Cycle,mech}','η_{Cycle,elec}','location','southeast');
xlabel('Wind speed at avg. pattern altitude (m/s)');
xlim([0 25]);
hold off

% Power plots
figure('units','inch','Position', [5 5 3.5 2.2])
hold on
grid on
box on
plot(Vw, system.PRO_mech./10^3,'-','linewidth',1.2);
plot(Vw, system.PRO_elec./10^3,'-','linewidth',1.2);
plot(Vw, system.Pcycle_elec./10^3,'-','linewidth',1.2);
ylabel('Power (kW)');
legend('PRO mech','PRO elec','Pcycle elec','location','northwest');
% legend('Cycle electrical power at grid','location','northwest');
xlabel('Wind speed at avg. pattern altitude (m/s)');
xlim([0 25]);
%ylim([0 160]);
hold off


%% Power curve comparison plot
% Loyd
% for i = 1:length(Vw)
%     P_Loyd(i) = (4/27)*(outputs.CL^3/outputs.CD_kite(i)^2)*(1/2)*1.225*inputs.WA*(Vw(i)^3);
%     if P_Loyd(i)>system.ratedPower
%         P_Loyd(i) = system.ratedPower;
%     end 
% end
% % AP3 6DoF simulation results
% AP3.PC.ws    = [7.32E+00, 8.02E+00, 9.05E+00, 1.00E+01, 1.10E+01, 1.20E+01, ...
%   1.30E+01, 1.41E+01, 1.50E+01, 1.60E+01, 1.70E+01, 1.80E+01, 1.90E+01]; %[m/s]
% AP3.PC.power = [0.00E+00, 7.01E+03, 2.37E+04, 4.31E+04, 6.47E+04, 8.46E+04, ...
%   1.02E+05, 1.20E+05, 1.34E+05, 1.49E+05, 1.50E+05, 1.50E+05, 1.50E+05]./10^3; %[kW]
% 
% figure('units','inch','Position', [5 5 3.5 2.2])
% hold on
% grid on
% box on
% plot(Vw, P_Loyd./10^3,'--','linewidth',1.2);
% plot(Vw, system.Pcycle_elec./10^3,'linewidth',1.5);
% plot(AP3.PC.ws, AP3.PC.power,'k^--','MarkerSize',4);
% legend('Loyd - Ideal','Model results','6DOF simulation','location','southeast');
% xlabel('Wind speed at avg. pattern altitude (m/s)');
% ylabel('Power (kW)');
% xlim([0 25]);
% %ylim([0 160]);
% hold off






