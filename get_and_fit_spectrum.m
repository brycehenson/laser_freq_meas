function dat=get_and_fit_spectrum(sa,opts)
    if isfield(opts,'doplots')
        opts.do_plots=false;
    end
    dat=[];
   
    spectrum=sa.spectrum;
    dat.time_meas=get_time_now_posix;

    spectrum_stat=[];
    spectrum_stat.mean=wmean(spectrum.freqs,db2pow(spectrum.pow));
    spectrum_stat.std=std(spectrum.freqs,db2pow(spectrum.pow));
    %%
    
    predictor=spectrum.freqs;
    response=db2pow(spectrum.pow)*1e6;
    
    cof_names={'sigma','mu','amp','offset'};
    fit_fun=@(b,x) b(3)*exp(-(1/2)*((x-b(2))./b(1)).^2)+b(4);
    %fit_fun=@(b,x) gaussian_function_1d(x,'sigma',b(1), 'mu',b(2),'amp',b(3),'offset',b(4));
    beta0=[spectrum_stat.std,spectrum_stat.mean,range(response),0];
    
    % cof_names={'sigma','gamma','mu','amp','offset'};
    % %gauss_fun=@(b,x) b(3)*exp(-(1/2)*((x-b(2))./b(1)).^2)+b(4);
    % fit_fun=@(b,x) voigt_function_1d(x,'sigma',b(1),'gamma',b(2), 'mu',b(3),'amp',b(4),'offset',b(5));
    % beta0=[laser_freq.std*xscale*0.5,laser_freq.std*xscale*0.5,mean(predictor),max(response),mean(response)];
    
    opt = statset('TolFun',1e-10,'TolX',1e-10,...
        'MaxIter',1e3,... %1e4
        'UseParallel',1);
    % weights=ones(size(predictor));
    % %'Weights',weights
    
    fitobj=fitnlm(predictor,response,fit_fun,beta0,...
        'options',opt,...
        'CoefficientNames',cof_names,'ErrorModel','constant'); %ErrorModel','proportional'
    %%

    dat.spectrum_stat=spectrum_stat;
    dat.fitob=fitobj;
    dat.fit_params.vals=fitobj.Coefficients.Estimate;
    dat.fit_params.SE=fitobj.Coefficients.SE;
    dat.fit_params.names=cof_names;

    %%
    if  opts.do_plots
        xscale=1e-6;
        stfig('raw spectrum')
        clf
        subplot(2,1,1)
        plot(spectrum.freqs*xscale,spectrum.pow)
        xlabel('freq (MHz)')
        ylabel('power (dbm)')
        subplot(2,1,2)
        plot(spectrum.freqs*xscale,db2pow(spectrum.pow))
        xlabel('freq (MHz)')
        ylabel('power (dbm)')
        %
        xplotvalues=linspace(min(predictor),max(predictor),1e4);
        xplotvalues=col_vec(xplotvalues);
        %size(xplotvalues)
        %amp_pred=fitobj.predict(xplotvalues); %'Alpha',1-erf(1/sqrt(2)),'Prediction','observation'
        %size(amp_pred)
        
        %size(xplotvalues)
        [amp_pred,ci]=predict(fitobj,xplotvalues,'Alpha',1-erf(1/sqrt(2)),'Prediction','observation'); %'Alpha',1-erf(1/sqrt(2)),'Prediction','curve','observation'
        %size(amp_pred)
        
        shaded_ci_lines=true;
        color_shaded=[0.5,0.7,0.5];
        
        stfig('fit spectrum')
        clf
        
        hold on
        if shaded_ci_lines
            p=patch([xplotvalues', fliplr(xplotvalues')]*xscale, [ci(:,1)', fliplr(ci(:,2)')], color_shaded,'EdgeColor','none');  %[1,1,1]*0.80
            p.FaceAlpha=0.5;
        else
            plot(xplotvalues*xscale,ci(:,1),'-','LineWidth',1.5)
            plot(xplotvalues*xscale,ci(:,2),'-','LineWidth',1.5)
        end  
        
        plot(predictor*xscale,response,'k.')
        plot(xplotvalues*xscale,amp_pred,'-','LineWidth',1.0)
        hold off
        
        xlabel('frequency')
        ylabel('power')
        pause(1e-4)
    end

end