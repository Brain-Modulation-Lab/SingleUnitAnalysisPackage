function varargout = OpenFile(varargin)
% OPENFILE Application M-file for OpenFile.fig
%    [FIG, FID, FILENAME] = OPENFILE() launch OpenFile GUI.
%    OPENFILE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 08-Jul-2003 11:10:30

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'), 'WindowStyle', 'modal');

	% Generate a structure of handles to pass to callbacks, and store it. 
    % Also initialize fid and filename fields to null values.
	handles = guihandles(fig);
    handles.path = '.';
    handles.fid = -1;
    handles.filename = '';
	guidata(fig, handles);
    
    % Load the contents of DirList
    load_DirList(handles.path, handles);

    % Wait for callbacks to run and window to be dismissed:
    uiwait(fig);
    
	if nargout > 0
        % Retrieve the latest copy of the 'handles' struct.
        handles = guidata(fig);
        % Return the fig handle, and selected file fid and filename.
		varargout{1} = fig;
        varargout{2} = handles.fid;
        varargout{3} = handles.filename;
	end    
    
    % Dismiss dialog box
    delete(fig);

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
function load_DirList(path, handles)

    % Display contents of current directory in the DirList listbox.
    d = dir(path); %get contents of current directory
    f = struct2cell(d(:)); %convert directory struct into a cell array
    set(handles.DirList, 'String', f(1,:), 'Value', 1); %display file names
    
    handles.dir = d;
    guidata(handles.OpenFile, handles);
    
    update_SelectedFilename(handles);
    
% --------------------------------------------------------------------
function update_SelectedFilename(handles)

% Get the index of the file selected in listbox
FileIndex = get(handles.DirList, 'Value');
% Get the filename corresponding to FileIndex
FileName = handles.dir(FileIndex).name;
set(handles.SelectedFilename, 'String', FileName);


% --------------------------------------------------------------------
function varargout = SelectedFilename_Callback(h, eventdata, handles, varargin)



% --------------------------------------------------------------------
function varargout = DirList_Callback(h, eventdata, handles, varargin)

update_SelectedFilename(handles);



% --------------------------------------------------------------------
function varargout = CancelButton_Callback(h, eventdata, handles, varargin)

uiresume(handles.OpenFile);


% --------------------------------------------------------------------
function varargout = OpenButton_Callback(h, eventdata, handles, varargin)

% Get the index of the file selected in listbox
FileIndex = get(handles.DirList, 'Value');
% If the item is a directory, display its contents
% Otherise, open the file
handles.path = [handles.path, '\', get(handles.SelectedFilename, 'String')];
guidata(handles.OpenFile, handles);
if handles.dir(FileIndex).isdir
    load_DirList(handles.path, handles);
else
    handles.fid = fopen(handles.path);
    handles.filename = get(handles.SelectedFilename, 'String');
    guidata(handles.OpenFile, handles);
    
    uiresume(handles.OpenFile);
end