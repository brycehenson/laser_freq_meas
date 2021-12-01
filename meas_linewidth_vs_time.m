addpath('./lib/Core_BEC_Analysis/lib/') %add the path to set_up_project_path, this will change if Core_BEC_Analysis is included as a submodule
                  % in this case it should be './lib/Core_BEC_Analysis/lib/'
set_up_project_path

hebec_constants %call the constants function that makes some globals


%%
if exist('sa','var')
    delete(sa)
    clear('sa')
end


sa=dsa800;
%%
sa.freq_cen=101.5e6;
sa.freq_span=200e3;
sa.param_coupling=true;
sa.auto_sweep_time=true;
sa.auto_rbw=true;
sa.auto_vbw=true;
sa.sweep_time=20;
sa.freq_rbw=1e3;
sa.freq_vbw
pause(1+sa.sweep_time)
spectrum=sa.spectrum;
stfig('raw spectrum')
subplot(2,1,1)
plot(spectrum.freqs*1e-6,spectrum.pow)
xlabel('freq (MHz)')
ylabel('power (dbm)')
subplot(2,1,2)
plot(spectrum.freqs*1e-6,db2pow(spectrum.pow))
xlabel('freq (MHz)')
ylabel('power (dbm)')

%%

predictor=spectrum.freqs*1e-6;
response=db2pow(spectrum.pow)*1e6;

cof_names={'sigma','mu','amp','offset'};
fit_fun=@(b,x) gaussian_function_1d(x,'sigma',b(1), 'mu',b(2),'amp',b(3),'offset',b(4));
beta0=[std(predictor,response),mean(predictor),max(response),mean(response)];

% cof_names={'sigma','gamma','mu','amp','offset'};
% %gauss_fun=@(b,x) b(3)*exp(-(1/2)*((x-b(2))./b(1)).^2)+b(4);
% fit_fun=@(b,x) voigt_function_1d(x,'sigma',b(1),'gamma',b(2), 'mu',b(3),'amp',b(4),'offset',b(5));
% beta0=[std(predictor,response)*0.5,std(predictor,response)*0.5,mean(predictor),max(response),mean(response)];



opt = statset('TolFun',1e-10,'TolX',1e-10,...
    'MaxIter',1e4,... %1e4
    'UseParallel',1);
% weights=ones(size(predictor));
% %'Weights',weights

fitobj=fitnlm(predictor,response,fit_fun,beta0,...
    'options',opt,...
    'CoefficientNames',cof_names);

%
xplotvalues=linspace(min(predictor),max(predictor),1e4);
xplotvalues=col_vec(xplotvalues);
size(xplotvalues)
amp_pred=fitobj.predict(xplotvalues); %'Alpha',1-erf(1/sqrt(2)),'Prediction','observation'
size(amp_pred)

size(xplotvalues)
[amp_pred,ci]=predict(fitobj,xplotvalues,'Alpha',1-erf(1/sqrt(2)),'Prediction','observation'); %'Alpha',1-erf(1/sqrt(2)),'Prediction','observation'
size(amp_pred)

shaded_ci_lines=true;
color_shaded=[0.5,0.7,0.5];

stfig('fit spectrum')
clf

hold on
if shaded_ci_lines
    p=patch([xplotvalues', fliplr(xplotvalues')], [ci(:,1)', fliplr(ci(:,2)')], color_shaded,'EdgeColor','none')  %[1,1,1]*0.80
    p.FaceAlpha=0.5
else
    plot(xplotvalues,ci(:,1),'-','LineWidth',1.5)
    plot(xplotvalues,ci(:,2),'-','LineWidth',1.5)
end  

plot(predictor,response,'k.')
plot(xplotvalues,amp_pred,'-','LineWidth',1.0)
hold off


%%
delete(sa)
clear('sa')