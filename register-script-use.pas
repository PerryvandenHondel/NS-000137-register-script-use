{ =====================================================================================================================

	PROGRAM:
		register-script-use.exe

	DESCRIPTION:
		Register the use of a script.
		
	VERSION:
		01	2015-04-23	PVDH	Initial version; dirty version; fixed path to export folder.

	RETURNS:
		Nothing
	
	FUNCTIONS AND PROCEDURES:
		function GetYearMonthFs
		procedure ProgramUsage
		
	
 =====================================================================================================================} 


program RegisterScriptUse;


{$mode objfpc}
{$H+}


uses
	Classes, 
	DateUtils,
	DOS,
	StrUtils,
	Sysutils,
	UTextFile,
	USplunkFile,
	USupportLibrary;

	
const	
	SHARE_LOG = '\\vm70as006.rec.nsint\000137-LOG\';
	
var
	tfLog: CTextFile;
	pathLog: string;
	line: string;
	scriptId: string;
	

function GetYearMonthFs(): string;
{
	Returns the current year and month in file system allowed format: YYYYMmm
} 
var
	year: word;
	month: word;
	mday: word;
	wday: word;
begin
	GetDate(year, month, mday, wday);
	GetYearMonthFs := IntToStr(year) + 'M' + NumberAlign(month, 2);
	// + NumberAlign(mday, 2);
end; // of function GetYearMonthFs

	
procedure ProgramUsage();
begin
	WriteLn();
	WriteLn('Usage:');
	WriteLn(Chr(9) + ParamStr(0) + ' [script-id]');
	WriteLn();
	WriteLn('Options:');
	WriteLn(Chr(9) + '[script-id]       ID of the script to register');
	WriteLn();
	WriteLn('Example:');
	WriteLn(Chr(9) + ParamStr(0) + ' 12');
	WriteLn();
end; // of procedure ProgramUsage()	
	
	
begin
	if ParamCount = 0 then
	begin
		ProgramUsage();
		Halt(0);
	end
	else
	begin
		scriptId := ParamStr(1);

		// Build the path to the log file
		pathLog := SHARE_LOG + GetYearMonthFs() + '.csv';
	
		WriteLn('Register the use of script ', scriptId, ' in log file ', pathLog);
			
		tfLog := CTextFile.Create(pathLog);
		tfLog.OpenFileWrite();	

		line := GetProperDateTime(Now()) + ';' + GetCurrentUserName() + ';' + scriptId;
	
		tfLog.WriteToFile(line);
	
		tfLog.CloseFile();
	end;
end. // of program RegisterScriptUse