classdef DVS128Demo < handle
    %DVS128 Demo Class for testing with datasets
    % maybe not all method are supported (experimental class)
    
    properties (SetAccess = private) 
        baudRate
        portName
        serial %serial Port
        demodata
        demodataI
        path
        filename
    end %properties
    
    events
        %TODO: Event based solution
        NewEvents
    end %events
    
    methods
        %TODO: create overload functions
        function obj = DVS128Demo(pN, bR)
            
            %set USB-Port configuration
            obj.baudRate = bR;
            obj.portName = pN;
        end %function DVS128()
        
        function Connect(obj)
                      
            %TODO: could be the reason of an Serial Port conflict (obj.SerPortCloseAll();)
            %obj.serial = SerialPort();
            %obj.serial.CloseAll();
            %obj.serial.Open(obj.portName, obj.baudRate);     
            disp ('COM-Port open');
            
            % clear input
            %obj.serial.Flush();                    
            %obj.Reset();
            
            % set data format with time stamp
            %obj.serial.WriteLine('!E2');         
            %pause(0.1);                         
            %obj.serial.Flush()
            disp('DVS128 enable timestamp');
            
            % start DVS128 event sendig
            %obj.serial.WriteLine('E+'); 
            % dummy read 3 chars as reply
            %obj.serial.Read(3);     
            
            % Load file
            %TODO select by Gui
            file = strcat(obj.path, obj.filename); 
            
            obj.demodata = load(file);
            obj.demodataI = 1;
            
            disp(strcat('DVS128 start event streaming from ', file));            

        end %connect()
        
        function setFileName(obj, path, name)
           obj.path = path;
           obj.filename = name;
           obj.Connect();
        end
        
        function Reset(obj)
            obj.serial.WriteLine('r');           
            pause(0.2);                             
            obj.serial.Flush();                  
            disp('DVS128 reset');
        end %reset()
        
        function Close(obj)
            obj.serial.WriteLine('E-');                     
            obj.serial.Close();                             
            disp ('COM-Port closed');  
        end %Close()
        
        function events = GetEvents(obj)  % get n events (=4*n bytes) from sensor
            events = [];
            events = obj.demodata.ans.dat{obj.demodataI};
            obj.demodataI = obj.demodataI +1;
            
            % reset after last element
            if obj.demodataI == length(obj.demodata.ans.dat)
                obj.demodataI = 1;
            end
        end %GetEvents
        
        function events = EventsAvailable(obj)
            a = size(obj.demodata.ans.dat);
            events = 0;
            if obj.demodataI < a(1)
                events = 1;
            end
            
        end %EventsAvailable

    end %methods
    

end

