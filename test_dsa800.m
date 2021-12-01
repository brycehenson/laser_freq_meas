sa=dsa800


%%
news_sweep_time=rand(1,1)*2;
a.sweep_time
a.sweep_time=news_sweep_time;
if abs(a.sweep_time-news_sweep_time)>news_sweep_time/1e3
    error('sweep time readback failed')
end



%%

spectrum=sa.spectrum


%%
delete(sa)
clear('sa')