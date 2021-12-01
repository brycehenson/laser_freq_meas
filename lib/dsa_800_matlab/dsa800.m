classdef dsa800 < handle
    properties
        inst_handle
        freq_start
        freq_stop
        sweep_time
        spectrum
    end
    methods
        function obj = dsa800()
            resourceList = visadevlist;
            idx=find(resourceList.Model=="DSA815");
            dev_name=resourceList.ResourceName(idx);
            v=visa('NI',dev_name);
            v.InputBufferSize=20000
            v.Timeout=1; %go fast
            fopen(v);
            obj.inst_handle=v;
        end

        function set.sweep_time(obj,t_sweep)
            fprintf(obj.inst_handle,':SWEep:TIME %f',t_sweep);
        end
        function sweep_time=get.sweep_time(obj)
            fprintf(obj.inst_handle,':SWEep:TIME?');
            st=fgets(obj.inst_handle);
            sweep_time=str2num(st);
        end

        function sp=get.spectrum(obj)
            fprintf(obj.inst_handle,':TRACe:DATA? TRACE1');
            st_pow=fgets(obj.inst_handle);
            % remove the header
            idx = strfind(st_pow,' ');
            idx=idx(1);
            st_pow=st_pow(idx:end);
            pow=textscan( st_pow, '%f', 'Delimiter',',' );
            pow=pow{1};
        
            freqs=transpose(linspace(obj.freq_start,obj.freq_stop,numel(pow)));
            sp=[];
            sp.pow=pow;
            sp.freqs=freqs;

        end


    end
    methods
        function delete(obj)
            fclose(obj.inst_handle);
            delete(obj.inst_handle)
        end
   end
end