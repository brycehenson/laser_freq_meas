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
sa.freq_span=300e3;
sa.param_coupling=true;
sa.auto_sweep_time=true;
sa.auto_rbw=true;
sa.auto_vbw=true;
sa.sweep_time=0.5;
sa.freq_rbw=1e3;
sa.freq_vbw

opts=[];
opts.do_plots=true;
dat=get_and_fit_spectrum(sa,opts)

%%
measurements={};
opts=[];
opts.do_plots=false;
sweep_time=sa.sweep_time;
for ii=1:3 00
    pause(sweep_time)
    measurements{ii}=get_and_fit_spectrum(sa,opts);
    fprintf('%u\n',ii)
end


%%

times=cellfun(@(x) x.time_meas,measurements) ;
times=times-times(1);
fit_freqs=cellfun(@(x) x.fit_params.vals(2),measurements) ;

plot(times,fit_freqs,'x')


%%
allan_in=[];
allan_in.freq=fit_freqs;
%allan_in.time=times;
allan_in.rate = 1/mean(diff(times));
allan(allan_in,(1/allan_in.rate)*(1:100))

%%
delete(sa)
clear('sa')