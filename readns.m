function varargout = ReadNS(varargin)
% READNS Application M-file for ReadNS.fig
%    FIG = READNS launch ReadNS GUI.
%    READNS('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 11-Oct-2005 12:57:11

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    handles.fid = -1;
    handles.F = [];
    handles.filename = '';
	guidata(fig, handles);

    update_SelectedEncoding(guidata(fig));
    update_Skip(guidata(fig));
    update_SamplingFrequency(guidata(fig));
    update_LengthSamples(guidata(fig));
    update_OpenEntireFile(guidata(fig));
    update_Preview(guidata(fig));
    update_PreviewLength(guidata(fig));
    update_ScaleFactor(guidata(fig));
    update_ChannelNum(guidata(fig), 0);
    
    % Wait for callbacks to run and window to be dismissed:
    uiwait(fig);
    
	if nargout > 0
        % Retrieve the latest copy of the 'handles' struct.
        if ishandle(fig)
            handles = guidata(fig);
        end
		%varargout{1} = fig;
        varargout{1} = handles.F;
        varargout{2} = handles.sampling_freq;
        varargout{3} = handles.filename;
	end
    
    ReadNS_CloseRequestFcn(fig, [], handles, varargin);

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end
end

% --------------------------------------------------------------------
function update_SelectedEncoding(handles)
val = get(handles.Encoding,'Value');
enc_list = get(handles.Encoding,'String');
handles.selected_enc = enc_list{val}; 
guidata(handles.ReadNS, handles);
update_ScaleFactor(handles);

% --------------------------------------------------------------------
function update_Skip(handles)
handles.skip = str2num(get(handles.Skip,'String')); 
guidata(handles.ReadNS, handles);

% --------------------------------------------------------------------
function update_SamplingFrequency(handles)
handles.sampling_freq = 1000*str2num(get(handles.SamplingFrequency,'String'));
guidata(handles.ReadNS, handles);
update_LengthSamples(handles);

% --------------------------------------------------------------------
function update_LengthSamples(handles)
handles.length = str2num(get(handles.LengthSamples,'String')); 
guidata(handles.ReadNS, handles);
set(handles.LengthSecs, 'String', num2str(handles.length/handles.sampling_freq));

% --------------------------------------------------------------------
function update_LengthSecs(handles)
length_secs = str2num(get(handles.LengthSecs,'String')); 
handles.length = length_secs*handles.sampling_freq; 
guidata(handles.ReadNS, handles);
set(handles.LengthSamples, 'String', num2str(handles.length));

% --------------------------------------------------------------------
function update_OpenEntireFile(handles)
handles.open_entire_file = get(handles.OpenEntireFile,'Value');
guidata(handles.ReadNS, handles);

% --------------------------------------------------------------------
function update_Preview(handles)
handles.preview = get(handles.Preview,'Value');
guidata(handles.ReadNS, handles);

% --------------------------------------------------------------------
function update_PreviewLength(handles);
handles.preview_length = str2num(get(handles.PreviewLength,'String')); 
guidata(handles.ReadNS, handles);

% --------------------------------------------------------------------
function update_ScaleFactor(handles)
handles.scale_factor = str2num(get(handles.ScaleFactor,'String')); 
% the following scale factors are calculated roughly for
% 16 and 32 bit signed integer encoding assuming a +/-10.000 Volt range
if strcmp(handles.selected_enc, 'int16')
    handles.scale_factor = 10000/(2^16-1);
    set(handles.ScaleFactor, 'String', num2str(handles.scale_factor));
elseif strcmp(handles.selected_enc, 'int32')
    handles.scale_factor = 10000/(2^32-1);
    set(handles.ScaleFactor, 'String', num2str(handles.scale_factor));
end
guidata(handles.ReadNS, handles);

% --------------------------------------------------------------------
function update_ChannelNum(handles, n)
curr_num = str2num(get(handles.ChannelNum,'String'));
if curr_num + n > 0
    handles.channel_num = curr_num + n;
    set(handles.ChannelNum, 'String', num2str(handles.channel_num));
    guidata(handles.ReadNS, handles);
end

% --------------------------------------------------------------------
function read_file(handles)
if(handles.fid > 0)
    
    frewind(handles.fid);
    F_raw = fread(handles.fid, handles.selected_enc);
    
    max_length = floor((length(F_raw)-handles.skip)/handles.channel_num);
    
    set(handles.MaxLength, 'String', num2str(max_length));
    
    if handles.open_entire_file
        set(handles.LengthSamples, 'String', num2str(max_length));
        update_LengthSamples(handles);
    end
    
    handles = guidata(handles.ReadNS);
    
    handles.F = zeros(handles.length, handles.channel_num);

    for i = 1:handles.channel_num
        handles.F(:,i) = handles.scale_factor*F_raw((handles.skip + handles.channel_num*(1:handles.length) - handles.channel_num + i)');
    end
    
    if handles.preview
        if(handles.preview_length > handles.length)
            handles.preview_length = handles.length;
            set(handles.PreviewLength, 'String', num2str(handles.preview_length));
        end
        set(handles.FilePreview, 'String', strcat(num2str((handles.skip+1:handles.skip+handles.preview_length)'), ': ', num2str(handles.F(1:handles.preview_length,:), '\t %12.8g')));
        set(handles.PlotButton, 'Enable', 'on');
    end
    guidata(handles.ReadNS, handles);
end


% --------------------------------------------------------------------
function varargout = Skip_Callback(h, eventdata, handles, varargin)
update_Skip(handles);

% --------------------------------------------------------------------
function varargout = Encoding_Callback(h, eventdata, handles, varargin)
update_SelectedEncoding(handles);

% --------------------------------------------------------------------
function varargout = ScaleFactor_Callback(h, eventdata, handles, varargin)
update_ScaleFactor(handles);

% --------------------------------------------------------------------
function varargout = SamplingFrequency_Callback(h, eventdata, handles, varargin)
update_SamplingFrequency(handles);

% --------------------------------------------------------------------
function varargout = LengthSamples_Callback(h, eventdata, handles, varargin)
update_LengthSamples(handles);

% --------------------------------------------------------------------
function varargout = LengthSecs_Callback(h, eventdata, handles, varargin)
update_LengthSecs(handles);

% --------------------------------------------------------------------
function varargout = OpenEntireFile_Callback(h, eventdata, handles, varargin)
update_OpenEntireFile(handles);

% --------------------------------------------------------------------
function varargout = Preview_Callback(h, eventdata, handles, varargin)
update_Preview(handles);

% --------------------------------------------------------------------
function varargout = PreviewLength_Callback(h, eventdata, handles, varargin)
update_PreviewLength(handles);

% --------------------------------------------------------------------
function varargout = DecrCh_Callback(h, eventdata, handles, varargin)
update_ChannelNum(handles, -1);

% --------------------------------------------------------------------
function varargout = IncrCh_Callback(h, eventdata, handles, varargin)
update_ChannelNum(handles, 1);

% --------------------------------------------------------------------
function varargout = open_submenu_Callback(h, eventdata, handles, varargin)
[fig, handles.fid, handles.filename] = openfile;
guidata(handles.ReadNS, handles);
if(~strcmp(handles.filename,''))
    set(handles.FileName, 'String', handles.filename);
end

% --------------------------------------------------------------------
function varargout = exit_submenu_Callback(h, eventdata, handles, varargin)
ReadNS_CloseRequestFcn(h, eventdata, handles, varargin);

% --------------------------------------------------------------------
function varargout = CancelButton_Callback(h, eventdata, handles, varargin)
ReadNS_CloseRequestFcn(h, eventdata, handles, varargin);

% --------------------------------------------------------------------
function varargout = ReadButton_Callback(h, eventdata, handles, varargin)
read_file(handles);

% --------------------------------------------------------------------
function varargout = SaveButton_Callback(h, eventdata, handles, varargin)
uiresume(handles.ReadNS);

% --------------------------------------------------------------------
function varargout = PlotButton_Callback(h, eventdata, handles, varargin)
figure;
plot(handles.F);

% ------------------------------------------------------------
% Callback for the GUI figure CloseRequestFcn property
% ------------------------------------------------------------
function varargout = ReadNS_CloseRequestFcn(h, eventdata, handles, varargin)
%close file if one is open
if(handles.fid > 0)
    fclose(handles.fid);
end
% close ReadNS figure
shh=get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
delete(get(0,'CurrentFigure'));
set(0,'ShowHiddenHandles',shh);

% --------------------------------------------------------------------
function varargout = file_menu_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = FilePreview_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = MaxLength_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ChannelNum_Callback(h, eventdata, handles, varargin)


% --- Executes during object creation, after setting all properties.
function ScaleFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


